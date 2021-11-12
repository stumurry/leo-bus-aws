'use strict'

const _ = require('lodash')
const mysql = require('mysql2/promise')
// const log = require('./log')
const Bluebird = require('bluebird')
const squel = require('squel').useFlavour('mysql')
squel.registerValueHandler(Date, (date) => {
  try {
    if (isNaN(date.getTime())) {
      return null
    }

    return date.toISOString()
  } catch (err) {
    console.log('date ' + date)

    throw err
  }
})

const streamToTable = async function (table, opts) {
  opts = Object.assign({
    records: 10000,
    useReplaceInto: false,
    onDupUpdate: false
  }, opts || {})
  const stream = this.bus.leo.streams.bufferBackoff((obj, done) => {
    done(null, obj, 1, 1)
  }, (records, callback) => {
    const getInsert = () => this.squel.insert()
    const getReplaceInto = () => this.squel.replace()

    const sql = (opts.useReplaceInto) ? getReplaceInto() : getInsert()

    sql.into(table)

    const getEID = (rec) => {
      return rec.eid
    }

    const getRecord = (rec) => {
      return rec.record
    }

    if (Array.isArray(records)) {
      sql.setFieldsRows(records.map(r => getRecord(r)))
    } else {
      sql.setFields(getRecord(records))
    }

    const query = sql.toParam()
    query.values = query.values.map(v => {
      return v === undefined ? null : v
    })

    this.execute(query.text, query.values)
      .then(rs => {
        callback(null, [])
      })
      .catch(err => {
        err.table = table
        err.query = sql.toString()

        this.bus.writeError(opts.client, records.map(r => getEID(r)), opts.event, err, records)

        callback(null, [])
      })
  }, {
    failAfter: 2
  }, {
    records: opts.records
  })

  stream.asyncEnd = () => {
    return new this.Promise((resolve, reject) => {
      stream.end(err => {
        if (err) {
          this.bus.writeError(opts.client, null, opts.event, err, null)
          resolve()
        } else resolve()
      })
    })
  }

  return stream
}

/**
 * @author ngoodrich
 * @since 9/6/2018
 * @param string table
 * @param object row
 * @param string primaryKey (temporary hack)
 *
 * @description This function is designed to do inserts/updates on individual records.
 * It will try to guess whether it is expected to do an insert or update based on the existence of
 * all data vs some portion of the data. Long-term this may not be a workable solution in the real world.
 *
 */
const upsert = async function (table, row, queryKey, primaryKey) {
  if (Object.keys(
    _.pickBy(row, (v, k) => {
      return ![undefined, null, ''].includes(v)
    })
  ).length === 0) {
    return
  }

  if (!Array.isArray(queryKey)) {
    queryKey = [queryKey]
  }

  if (!primaryKey) {
    primaryKey = queryKey
  } else if (!Array.isArray(primaryKey)) {
    primaryKey = [primaryKey]
  }

  const tblDef = await this.getTableDefinition(table, primaryKey)

  // this will be slow as anything but it should work 100% of the time -- ndg 9/6/2018
  let insert
  const rowContainsPk = tblDef.primary_key.some(k => k in row)

  if (primaryKey === queryKey && !rowContainsPk) {
    insert = true
  } else {
    const check = this.squel.select()
      .from(table)

    queryKey.map(k => {
      if ([undefined, ''].includes(row[k])) {
        row[k] = null
      }

      if (row[k] === null) {
        check.where(`${k} IS NULL`)
      } else {
        check.where(`${k} = ?`, row[k])
      }

      check.field(k)
    })

    const query = check.toParam()
    try {
      insert = await this.execute(query.text, query.values).then(rs => rs[0].length === 0)
    } catch (err) {
      err.table = table
      err.query = check.toString()

      throw err
    }
  }

  const getUpdate = () => {
    _.forOwn(row, (val, key) => {
      const col = tblDef.columns.find(c => c.column_name === key)

      if (val === undefined || (val === '' && col.is_nullable === 'YES')) {
        row[key] = null
      }
    })

    const sql = this.squel.update().table(table).setFields(row)
    queryKey.map(k => {
      if (row[k] === null) {
        sql.where(`${k} IS NULL`)
      } else {
        sql.where(`${k} = ?`, [row[k]])
      }
    })
    return sql
  }

  const getInsert = () => {
    // remove any fields that do not have a value that are nullable -- ndg 9/11/2018
    const fields = _.pick(row, tblDef.columns
      .filter(c => !([undefined, null].includes(row[c.column_name]) || (row[c.column_name] === '' && c.is_nullable === 'YES')))
      .map(c => c.column_name)
    )

    return this.squel.insert()
      .into(table)
      .setFields(fields)
  }

  const sql = insert ? getInsert() : getUpdate()

  const query = sql.toParam()
  return this.execute(query.text, query.values).then(rs => {
    rs = rs[0]

    if (rs.insertId) {
      const id = tblDef.primary_key[0]
      const obj = {}

      obj[id] = rs.insertId

      return obj
    }

    return _.pick(row, tblDef.primary_key)
  }).catch(err => {
    err.query = sql.toString()
    err.table = table

    throw err
  })
}

const getTableDefinition = async function (table, primaryKey) {
  if (table in this.tables) {
    if (this.tables[table]) {
      return this.tables[table]
    } else {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          resolve()
        }, 250)
      }).then(() => {
        return this.getTableDefinition(table, primaryKey)
      })
    }
  }

  this.tables[table] = undefined

  const cols = this.squel.select()
    .from('information_schema.columns')
    .field('column_name')
    .field('column_default')
    .field('is_nullable')
    .field('data_type')
    .where('table_schema = ?', this.pool.config.connectionConfig.database)
    .where('table_name = ?', table)
    .toParam()

  const columns = await this.execute(cols.text, cols.values)
    .then(rs => {
      return rs[0]
    })

  this.tables[table] = {
    name: table,
    columns: columns,
    primary_key: primaryKey
  }

  return this.tables[table]
}

const lookup = async function (table, data, opts) {
  const cols = this.squel.select()
    .fields(opts.fields)
    .from(table)
    .where(opts.lookupField + ' = ?', data[opts.lookupField])
    .toParam()
  return this.execute(cols.text, cols.values).then(c => c[0])
}

module.exports = async (params) => {
  let bus
  if (params.bus) {
    bus = params.bus
    delete params.bus
  }

  const pool = await mysql.createPool(Object.assign({ Promise: Bluebird }, params))

  if (bus) {
    pool.bus = bus
  }

  pool.tables = {}
  pool.getTableDefinition = getTableDefinition
  pool.upsert = upsert
  pool.lookup = lookup
  pool.streamToTable = streamToTable
  pool.squel = squel

  return pool
}
