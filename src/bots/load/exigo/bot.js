'use strict'
const Bot = require('../../bot')
const connector = require('leo-connector-sqlserver')
const mssql = require('mssql')
const Log = require('../../../libs/log')

const connections = {}

connector.connect = (config) => {
  // make the config parameters the same as the other database types.
  if (config.host && typeof config.server === 'undefined') {
    config.server = config.host
  }
  config = Object.assign({
    user: 'root',
    password: 'test',
    server: 'localhost',
    database: 'sourcedata',
    port: 1433,
    requestTimeout: 1000 * 50,
    pool: {
      max: 1
    }
  }, config)

  const connectionHash = JSON.stringify(config)
  let pool
  let isConnected = false
  const buffer = []

  if (!connections[connectionHash]) {
    console.log('CREATING NEW SQLSERVER CONNECTION (WITH NEW FIX)')
    pool = connections[connectionHash] = new mssql.ConnectionPool(config)

    pool.connect(err => {
      // console.log("Got a connection thing", err, buffer.length)
      isConnected = true
      if (err) {
        console.log(err)
        process.exit()
      } else if (buffer.length) {
        buffer.forEach(i => {
          client.query(i.query, i.params, (err, result, fields) => {
            i.callback(err, result, fields)
          }, i.opts)
        })
      }
    })
  } else {
    console.log('REUSING SQLSERVER CONNECTION')
    pool = connections[connectionHash]
    isConnected = true
  }

  let queryCount = 0
  const client = {
    query: function (query, params, callback, opts = {}) {
      if (typeof params === 'function') {
        opts = callback
        callback = params
        params = {}
      }
      opts = Object.assign({
        inRowMode: true,
        stream: false
      }, opts || {})

      if (!isConnected) {
        console.log('buffering query')
        buffer.push({
          query: query,
          params: params,
          callback: callback,
          opts: opts
        })
      } else {
        const queryId = ++queryCount
        // let log = logger.sub('query')
        const request = pool.request()
        Log.info(`SQL query #${queryId} is `, query)
        // Log.time(`Ran Query #${queryId}`)

        if (params) {
          for (const i in params) {
            request.input(i, params[i])
          }
        }
        let queryType = 'query'
        if (opts.inRowMode) {
          queryType = 'queryRow'
        }
        if (opts.stream === true) {
          request.stream = true
        }
        request[queryType](query, function (err, result) {
          // Log.timeEnd(`Ran Query #${queryId}`)
          if (err) {
            Log.error(`Had error #${queryId}`, query, err)
            if (callback) callback(err)
          } else {
            const columns = result.columns || (result.recordset && Object.keys(result.recordset[0] || {}).map(k => ({
              name: k
            })))
            if (callback) callback(null, result.recordset, columns)
          }
        })

        return request
      }
    },
    queryRow: function (query, params, callback, opts = {}) {
      if (typeof params === 'function') {
        opts = callback
        callback = params
        params = {}
      }
      return this.query(query, params, callback, Object.assign(opts, {
        inRowMode: true
      }))
    },
    range: function (table, id, opts, callback) {
      client.query(`select min(${id}) as min, max(${id}) as max, count(${id}) as total from ${table}`, (err, result) => {
        if (err) return callback(err)
        callback(null, {
          min: result[0].min,
          max: result[0].max,
          total: result[0].total
        })
      }, { inRowMode: false })
    },
    nibble: function (table, id, start, min, max, limit, reverse, callback) {
      let sql
      if (reverse) {
        sql = `select ${id} as id from ${table}  
where ${id} <= ${start} and ${id} >= ${min}
ORDER BY ${id} desc
OFFSET ${limit - 1} ROWS 
FETCH NEXT 2 ROWS ONLY`
      } else {
        sql = `select ${id} as id from ${table}  
where ${id} >= ${start} and ${id} <= ${max}
ORDER BY ${id} asc
OFFSET ${limit - 1} ROWS 
FETCH NEXT 2 ROWS ONLY`
      }

      client.query(sql, callback, { inRowMode: false })
    },
    getIds: function (table, id, start, end, reverse, callback) {
      let sql
      if (reverse) {
        sql = `select ${id} as id from ${table}  
where ${id} <= ${start} and ${id} >= ${end}
ORDER BY ${id} desc`
      } else {
        sql = `select ${id} as id from ${table}  
where ${id} >= ${start} and ${id} <= ${end}
ORDER BY ${id} asc`
      }

      client.query(sql, callback, { inRowMode: false })
    },
    end: function (callback) {
      let err

      try {
        connections[connectionHash] = undefined
        pool.close()
      } catch (e) {
        err = e
      }

      if (callback) {
        callback(err)
      } else if (err) {
        throw err
      }
    }
  }
  return client
}

class LoadExigoBot extends Bot {
  getTableIdTranslations () {
    throw new Error('Abstract method getTableIdTranslations must be implemented in child class')
  }

  getDomainObject (dol) {
    throw new Error('Abstract method getDomainObject must be implemented in child class')
  }

  /**
   * @author s murry
   * c = { Customers : [1 ,2, 3] } //  Pass the table of deleted ids
   *
   * Right now we are just logging these values.  To Do:  Implement is parent class.
   *
   */
  deletedItems (c) {
    Log.info(this.icentris_client, 'Deleted items:', {
      data: c
    })
  }

  transform (c) {
    throw new Error('Abstract method transform must be implemented in child class')
  }

  getDomainIdColumn () {
    throw new Error('Abstract method getDomainIdColumn must be implemented in child class')
  }

  /**
   * @author w brito
   * @description Override for translateIdsStartStream from leo-connector-common/dol.js
   *  Adding support for delete and insert in the domain object
   *
  */
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
    const ls = this.bus.leo.streams
    const settings = Object.assign({
    }, event)
    const cfg = await this.getConfig(settings.icentris_client).then(c => {
      return c.exigo
    })

    const dol = connector.domainObjectBuilder(cfg)
    dol.translateIdsStartStream = this.translateIdsStartStream.bind(this)
    const tableIdTranslations = this.getTableIdTranslations()
    const domainObject = this.getDomainObject(dol)
    domainObject.transform = this.transform
    domainObject.domainIdColumn = this.getDomainIdColumn()
    const stats = ls.stats(settings.bot_id, this.bus.getQueue(settings.source))
    return new Promise((resolve, reject) => {
      ls.pipe(
        ls.fromLeo(settings.bot_id, settings.source),
        dol.translateIds(tableIdTranslations),
        dol.domainObjectTransform(domainObject),
        stats,
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
module.exports = LoadExigoBot
