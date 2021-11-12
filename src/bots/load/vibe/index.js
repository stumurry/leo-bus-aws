'use strict'

const Bot = require('../../bot')
const mysql = require('mysql2')
const connector = require('leo-connector-mysql')
const logger = require('leo-logger')('leo.connector.sql.mysql')
const ls = require('leo-sdk').streams
const connections = {}

connector.connect = (config) => {
  const connectionHash = JSON.stringify(config)

  if (!connections[connectionHash]) {
    console.log('CREATING NEW MYSQL CONNECTION (Override)')
    connections[connectionHash] = mysql.createPool(config)
  } else {
    console.log('REUSING CONNECTION (Override)')
  }
  const pool = connections[connectionHash]

  const cache = {
    schema: {},
    timestamp: null
  }

  let queryCount = 0
  const client = {
    setAuditdate,
    connect: function (opts) {
      opts = opts || {}
      return new Promise((resolve, reject) => {
        pool.getConnection((error, connection) => {
          if (error) {
            reject(error)
          }
          resolve(connection)
        })
      })
    },
    query: function (query, params, callback, opts = {}) {
      if (typeof params === 'function') {
        opts = callback
        callback = params
        params = []
      }
      opts = Object.assign({
        inRowMode: false,
        stream: false
      }, opts || {})

      const queryId = ++queryCount
      const log = logger.sub('query')
      log.info(`SQL query #${queryId} is `, query, params && params.length ? params : '')
      log.time(`Ran Query #${queryId}`)

      pool.query({
        sql: query,
        rowsAsArray: opts.inRowMode
      }, params, function (err, result, dbfields) {
        log.timeEnd(`Ran Query #${queryId}`)
        let fields
        if (err) {
          log.error(`Had error #${queryId}`, query, err)
        } else if (dbfields) {
          // make fields interchangeable between mysql and mysql2 node modules
          fields = dbfields.map(data => {
            const startingObj = {
              type: data.columnType,
              db: data.schema,
              length: data.columnLength,
              schema: ''
            }

            Object.keys(data).filter(f => !f.match(/^_/)).filter(f => data[f]).map(k => {
              startingObj[k] = data[k]
            })

            return startingObj
          })
        }

        callback(err, result, fields)
      })
    },
    end: function (callback) {
      connections[connectionHash] = undefined
      return pool.end(callback)
    },
    disconnect: function (callback) {
      return this.end(callback)
    },
    release: function (destroy) {
      pool.release && pool.release(destroy)
    },
    describeTable: function (table, callback, tableSchema = config.database) {
      const qualifiedTable = `${tableSchema}.${table}`
      if (cache.schema[qualifiedTable]) {
        callback(null, cache.schema[qualifiedTable] || [])
      } else {
        this.clearSchemaCache()
        this.describeTables((err, schema) => {
          callback(err, (schema && schema[qualifiedTable]) || [])
        }, tableSchema)
      }
    },
    describeTables: function (callback, tableSchema = config.database) {
      if (Object.keys(cache.schema || {}).length) {
        logger.info('Tables schema from cache', cache.timestamp)
        return callback(null, cache.schema)
      }
      client.query(`SELECT table_name, column_name, data_type, is_nullable, character_maximum_length FROM information_schema.columns WHERE table_schema = '${tableSchema}' order by ordinal_position asc`, (err, result) => {
        const schema = {}
        result && result.map(tableInfo => {
          const tableName = `${tableSchema}.${tableInfo.table_name}`
          if (!schema[tableName]) {
            schema[tableName] = []
          }
          schema[tableName].push(tableInfo)
        })
        Object.keys(schema).map((key) => {
          const parts = key.match(/^datawarehouse\.(.*)$/)
          if (parts) {
            schema[parts[1]] = schema[key]
          }
        })
        cache.schema = schema
        cache.timestamp = Date.now()
        logger.info('Caching Schema Table', cache.timestamp)
        callback(err, cache.schema)
      })
    },
    getSchemaCache: function () {
      return cache.schema || {}
    },
    setSchemaCache: function (schema) {
      cache.schema = schema || {}
    },
    clearSchemaCache: function () {
      logger.info('Clearing Tables schema cache')
      cache.schema = {}
    },
    streamToTableFromS3: function (table, opts) {

    },
    streamToTableBatch: function (table, opts) {
      opts = Object.assign({
        records: 10000,
        useReplaceInto: false
      }, opts || {})
      let pending = null
      let columns = []
      let ready = false
      let total = 0
      client.query(`SELECT column_name
          FROM information_schema.columns
          WHERE table_schema = '${config.database}' and table_name = ${escapeValue(table)} order by ordinal_position asc`, (err, results) => {
        if (err) {
          // satisfy standard - Expected error to be handled.
        }

        columns = results.map(r => r.column_name)
        ready = true
        if (pending) {
          pending()
        }
      })
      return ls.bufferBackoff((obj, done) => {
        if (!ready) {
          pending = () => {
            done(null, obj, 1, 1)
          }
        } else {
          done(null, obj, 1, 1)
        }
      }, (records, callback) => {
        if (opts.useReplaceInto) {
          console.log('Replace Inserting ' + records.length + ' records of ', total)
        } else {
          console.log('Inserting ' + records.length + ' records of ', total)
        }
        total += records.length

        var values = records.map((r) => {
          return columns.map(f => r[f])
        })

        let cmd = 'INSERT INTO '
        if (opts.useReplaceInto) {
          cmd = 'REPLACE INTO '
        }
        client.query(`${cmd} ${config.database}.${escapeId(table)} (??) VALUES ?`, [columns, values], function (err) {
          if (err) {
            callback(err)
          } else {
            callback(null, [])
          }
        })
      }, {
        failAfter: 2
      }, {
        records: opts.records
      })
    },
    streamToTable: function (table, opts) {
      opts = Object.assign({
        records: 10000
      })
      return this.streamToTableBatch(table, opts)
    },
    range: function (table, id, opts, callback) {
      // handle composite keys
      if (Array.isArray(id)) {
        const fieldPlaceHolders = []
        const params = []
        const SPLIT_KEY = '::'

        // set min and placeholders
        for (const key of id) {
          params.push(key)
          fieldPlaceHolders.push('??')
        }

        // set max. placeholders are done.
        let key
        for (key of id) {
          params.push(key)
        }

        // just push the last key on again for the count
        params.push(key)

        const minKey = 'CONCAT(MIN(' + fieldPlaceHolders.join(`), '${SPLIT_KEY}', MIN(`) + '))'
        const maxKey = 'CONCAT(MAX(' + fieldPlaceHolders.join(`), '${SPLIT_KEY}', MAX(`) + '))'

        // add the table at the end
        params.push(table)

        client.query(`SELECT ${minKey} AS min, ${maxKey} AS max, COUNT(??) AS total FROM ??`, params, (err, result) => {
          if (err) return callback(err)

          const results = {
            min: {},
            max: {},
            total: result[0].total
          }
          const min = result[0].min.split(SPLIT_KEY)
          const max = result[0].max.split(SPLIT_KEY)

          for (const i in id) {
            results.min[id[i]] = min[i]
            results.max[id[i]] = max[i]
          }

          callback(null, results)
        })
      } else { // do things normally
        const params = [id, id, id, table]
        client.query('select min(??) as min, max(??) as max, count(??) as total from ??', params, (err, result) => {
          if (err) return callback(err)
          callback(null, {
            min: result[0].min,
            max: result[0].max,
            total: result[0].total
          })
        })
      }
    },
    nibble: function (table, id, start, min, max, limit, reverse, callback) {
      let sql
      let params = []

      // handle composite keys
      if (Array.isArray(id)) {
        const selectPieces = []
        const orderByParams = []

        for (const key of id) {
          selectPieces.push('??')
          params.push(key)
          // collect params for order by. Will be pushed on later.
          orderByParams.push(key)
        }

        // push the table on right after the fields
        params.push(table)

        let where = []
        const orderDirection = (reverse) ? 'DESC' : 'ASC'
        const startDirection = (reverse) ? '<=' : '>='
        const endDirection = (reverse) ? '>=' : '<='
        const values = (reverse) ? min : max

        // build the where clause
        for (const key in values) {
          where.push(`(?? ${startDirection} ? AND ?? ${endDirection} ?)`)

          params.push(key)
          params.push(start[key])
          params.push(key)
          params.push(values[key])
        }
        where = where.join(' AND ')

        // build the order
        const order = selectPieces.join(` ${orderDirection},`) + ` ${orderDirection}`

        // push on additional parameters for the order by
        params.push(...orderByParams)

        sql = `SELECT ${selectPieces.join(', ')}
          FROM ??
          WHERE ${where}
          ORDER BY ${order}
          LIMIT ${limit - 1},2`
      } else {
        if (reverse) {
          sql = `select ?? as id from ??
              where ?? <= ? and ?? >= ?
              ORDER BY ?? desc
              LIMIT ${limit - 1},2`
          params = [id, table, id, start, id, min, id]
        } else {
          sql = `select ?? as id from ??
              where ?? >= ? and ?? <= ?
              ORDER BY ?? asc
              LIMIT ${limit - 1},2`
          params = [id, table, id, start, id, max, id]
        }
      }

      client.query(sql, params, callback)
    },
    getIds: function (table, id, start, end, reverse, callback) {
      let sql
      let params = []

      if (Array.isArray(id)) {
        const direction = (reverse) ? 'DESC' : 'ASC'
        const startDirection = (reverse) ? '<=' : '>='
        const endDirection = (reverse) ? '>=' : '<='
        const select = []
        const where = []
        const whereParams = []
        const order = []

        for (const key of id) {
          select.push('??')
          params.push(key)

          where.push(`(?? ${startDirection} ? AND ?? ${endDirection} ?)`)
          whereParams.push(key)
          whereParams.push(start[key])
          whereParams.push(key)
          whereParams.push(end[key])

          order.push(`${key} ${direction}`)
        }

        params.push(table)
        params.push(...whereParams)

        sql = `SELECT ${select.join(',')}
          FROM ??
          WHERE ${where.join(' AND ')}
          ORDER BY ${order.join(',')}`
      } else {
        if (reverse) {
          sql = `select ?? as id from ??
                            where ?? <= ? and ?? >= ?
                            ORDER BY ?? desc`
        } else {
          sql = `select ?? as id from ??
                            where ?? >= ? and ?? <= ?
                            ORDER BY ?? asc`
        }
        params = [id, table, id, start, id, end, id]
      }

      client.query(sql, params, callback)
    },
    escapeId,
    escape: function (value) {
      if (value.replace) {
        return '`' + value.replace('`', '') + '`'
      } else {
        return value
      }
    },
    escapeValue,
    escapeValueNoToLower: function (value) {
      if (value.replace) {
        return '\'' + value.replace('\'', '\\\'') + '\''
      } else {
        return value
      }
    }
  }

  function escapeId (field) {
    return '`' + field.replace('`', '').replace(/\.([^.]+)$/, '`.`$1') + '`'
  }

  function escapeValue (value) {
    if (value.replace) {
      return '\'' + value.replace('\'', '\\\'').toLowerCase() + '\''
    } else {
      return value
    }
  }

  function setAuditdate () {
    client.auditdate = '\'' + new Date().toISOString().replace(/\.\d*Z/, '').replace(/[A-Z]/, ' ') + '\''
  }

  return client
}

class LoadVibeBot extends Bot {
  getTableIdTranslations (table) {
    let translations = {}
    translations[table] = true
    return translations
  }

  getDomainObject (dol, table) {
    return dol.domainObject(
      c => `
      SELECT
        t.id AS '_domain_id',
        t.*
      FROM \`${table}\` AS t
      WHERE t.id IN (${c.ids});
      `
    )
  }

  translateIdsStartStream (idTranslation) {
    const ls = this.bus.leo.streams
    return ls.through((obj, done, push) => {
      let last = null
      let count = 0
      // in the built in method this is updates
      const statements = Object.assign({}, obj.payload)
      if (Object.keys({ ...obj.payload.update, ...obj.payload.insert }).length === 0) {
        return done(null, {
          correlation_id: {
            source: obj.event,
            start: obj.eid
          }
        })
      }
      for (const stm in statements) {
        const statementType = statements[stm]
        for (const schema in statementType) {
          for (const t in idTranslation) {
            let ids = statementType[schema][t]
            if (!ids) {
              continue
            }
            ids = Array.from(new Set(ids)) // Dedup the ids
            for (let i = 0; i < ids.length; i++) {
              if (count) push(last)
              last = {
                s: schema,
                t,
                id: ids[i],
                correlation_id: {
                  source: obj.event,
                  partial: obj.eid,
                  units: 1
                }
              }
              count++
            }
          }
        }
      }
      if (last) {
        last.correlation_id = {
          source: obj.event,
          start: obj.eid,
          units: 1
        }
        done(null, last)
      } else {
        done(null, {
          correlation_id: {
            source: obj.event,
            start: obj.eid,
            units: 1
          }
        })
      }
    })
  }

  async handle (event, context) {
    const leo = this.bus.leo
    const settings = Object.assign({

    }, event)

    const mysqlCfg = await this.getConfig(settings.icentris_client).then(cfg => {
      return cfg.vibe.mysql
    })

    const dol = connector.domainObjectBuilder(mysqlCfg)
    dol.translateIdsStartStream = this.translateIdsStartStream.bind(this)
    const tableIdTranslations = this.getTableIdTranslations(settings.table)
    const domainObject = this.getDomainObject(dol, settings.table)
    const stats = ls.stats(settings.bot_id, settings.source)

    return new Promise((resolve, reject) => {
      ls.pipe(
        ls.fromLeo(settings.bot_id, settings.source),
        stats,
        dol.translateIds(tableIdTranslations),
        dol.domainObjectTransform(domainObject),
        ls.through((obj, done) => {
          if (Object.keys(obj.payload).length === 0) {
            done(null)
          } else {
            obj.payload.icentris_client = settings.icentris_client
            done(null, obj)
          }
        }),
        leo.load(settings.bot_id, settings.destination),
        (err) => {
          this.closeConnection(dol.client, err, resolve, reject, stats)
        }
      )
    })
  }
}

module.exports = new LoadVibeBot()
