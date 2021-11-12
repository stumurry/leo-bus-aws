'use strict'

const Bot = require('../bot')
const s3 = require('../../../../libs/s3')
const fieldMap = require('./field_map')

class TreeBot extends Bot {
  async each (payload, meta) {
    if (!this.type) {
      throw new Error('type not specified for each function!')
    }

    if (payload.type !== this.type) {
      return
    }

    let conn
    const ls = this.bus.leo.streams
    const client = payload.icentris_client
    const tbl = `tree_${this.type}s`
    const stg = `staging_${tbl}`

    const bucket = `icentris-bus-${process.env.NODE_ENV}`
    const path = `tree/${this.type}/`
    const ndjson = `${client}.ndjson`
    const read = `${client}.read.ndjson`

    return s3.rename(bucket, `${path}${ndjson}`, `${path}${read}`)
      .then(() => {
        return this.getVibeDB(client)
          .then(async db => {
            conn = db
            await conn.query(`DROP TABLE IF EXISTS ${stg}`)
            await conn.query(`CREATE TABLE ${stg} LIKE ${tbl}`)
          })
          .then(() => {
            return this.getTableWriteStream(client, stg, { records: 70000 })
              .then(writeStr => {
                let i = 0

                return new Promise((resolve, reject) => {
                  ls.pipe(ls.fromS3({ bucket: bucket, key: `${path}${read}` }), ls.parse(), ls.through((obj, done) => {
                    obj = this.translate(this.getClientMap(fieldMap, payload.icentris_client), obj)
                    done(null, {
                      record: Object.assign(obj, { id: ++i }),
                      eid: meta.eid
                    })
                  }), writeStr, err => {
                    if (err) {
                      reject(err)
                    } else {
                      delete this.streams[client][stg]
                      resolve()
                    }
                  })
                })
              })
          })
          .then(async () => {
            await conn.query(`DROP TABLE ${tbl}`)
            await conn.query(`ALTER TABLE ${stg} RENAME TO ${tbl}`)
          })
      })
  }
}

module.exports = TreeBot
