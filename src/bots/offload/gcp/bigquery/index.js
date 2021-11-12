'use strict'
const Bot = require('../../../bot')
const streams = require('../../../../libs/streams')
const fs = require('fs')
const tmp = require('tmp')
const moment = require('moment')

class OffloadGCPBigQuery extends Bot {
  enrichForBigQuery (ls, config) {
    return ls.through((obj, done) => {
      obj.payload.ingestion_timestamp = new Date()
      obj.payload.leo_eid = obj.eid
      done(null, obj)
    })
  }

  processDatetimeFields (ls, schema) {
    return ls.through((obj, done) => {
      obj.payload = this.formatDatetime(obj.payload, schema)
      done(null, obj)
    })
  }

  formatDatetime (payload, schema) {
    // Remove timezone from DATETIME fields - jc 1/21/2020
    schema.fields.forEach(f => {
      if (f.type === 'DATETIME') {
        console.log(`Format ${f.name} field`)
        payload[f.name] = payload[f.name] ? moment(payload[f.name]).format('YYYY-MM-DD HH:mm:ss.SSS') : payload[f.name]
      } else if (f.type === 'DATE') {
        console.log(`Format ${f.name} field`)
        payload[f.name] = payload[f.name] ? moment(payload[f.name]).format('YYYY-MM-DD') : payload[f.name]
      } else if (f.type === 'RECORD') {
        console.log(`Recurse ${f.name} field`)
        payload[f.name].forEach(r => {
          this.formatDatetime(r, { fields: f.fields })
        })
      }
    })
    return payload
  }

  async handle (event, context) {
    // Switch between the two for functional testing - Stu M. 4/15/20
    // When the leo-cli copies the files to Lambda, the @google-cloud is chopped
    // const { BigQuery } = require('@google-cloud/bigquery')
    let bq
    if (process.env.IS_TEST_ENV === 'YES') {
      bq = require('@google-cloud/bigquery')
    } else {
      bq = require('bigquery')
    }

    const leo = this.bus.leo
    const ls = leo.streams
    const settings = Object.assign({}, event)

    await this.getRemoteConfig().then(config => {
      settings.config = config
    })

    const bigquery = new bq.BigQuery(settings.config.gcp)
    const dataset = bigquery.dataset(`${settings.data_set}`)
    const databusIngressDataSet = (await dataset.get())[0]
    const table = databusIngressDataSet.table(settings.table_name)
    await table.get()

    const stats = ls.stats(settings.botId, settings.queue)
    return new Promise((resolve, reject) => {
      tmp.file((err, tempFile, fd, cleanupCallback) => {
        if (err) throw err
        ls.pipe(
          ls.fromLeo(settings.botId, settings.queue),
          stats,
          streams.checkEmptyPayload(ls),
          this.enrichForBigQuery(ls, settings.config.bus.tenant),
          this.processDatetimeFields(ls, table.metadata.schema),
          streams.stringifyJsonNewlineDelimited(ls),
          fs.createWriteStream(tempFile),
          (err) => {
            /**
             * @author S.Murry
             * @date 9/18/19
             * Functional tests use a real checkpoint stored in aws local leo bus.
             * When the time comes that this checkpoint gets corrupted,
             * simply uncomment the line below and run the test once.
             *
             * stats.checkpoint(resolve)
             *
             * This will advance the current checkpoint to now.  Then re-comment the line above and rerun your tests.
             */
            if (err) {
              console.log('error', err)
              reject(err)
              cleanupCallback()
            } else {
              const fileStats = fs.statSync(tempFile)
              if (fileStats.size === 0) {
                console.log('No records to load to BigQuery... All done.')
                stats.checkpoint(resolve)
                cleanupCallback()
              }

              this.loadTempFileToBigQuery(bigquery, table, tempFile)
                .then(() => {
                  stats.checkpoint(resolve)
                  cleanupCallback()
                })
                .catch(err => { console.log('failed to load temp file to bigquery', err); reject(err); cleanupCallback() })
            }
          }
        )
      })
    })
  }

  async loadTempFileToBigQuery (bigquery, table, tempFile) {
    const metadata = {
      sourceFormat: 'NEWLINE_DELIMITED_JSON',
      schema: table.metadata.schema,
      location: 'US'
    }

    const [job] = await bigquery
      .dataset(table.metadata.tableReference.datasetId)
      .table(table.metadata.tableReference.tableId)
      .load(tempFile, metadata)

    console.log(`Job ${job.id} completed.`)
  }
}
module.exports = new OffloadGCPBigQuery()
