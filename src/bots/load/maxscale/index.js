'use strict'

const Bot = require('../../bot')
const Log = require('../../../libs/log')
const utils = require('../../../libs/utils')
const ls = require('leo-sdk').streams
const stream = require('stream')

class LoadMaxscaleCDCBot extends Bot {
  constructor (opts) {
    super(opts)

    /**
     * @author Jon Cain
     * @date 9/4/2019
     * @summary By default, write payloads to S3 (rather than Kinesis). Unit tests set this to false due to mock complexities.
     */
    this.useS3 = true
  }

  async handle (event, context) {
    Log.info(event.icentris_client, 'Calling Max CDC')
    Log.info(event.icentris_client, event)
    Log.info(event.icentris_client, context)

    const settings = Object.assign({
      runAgain: true,
      duration: context.getRemainingTimeInMillis() * 0.8
    }, event)
    const cfg = await this.getRemoteConfig()
    this.maxCdcCfg = cfg.bus.tenant[settings.icentris_client].maxscale
    const ls = this.bus.leo.streams
    const bucket = `${settings.bucket}-${process.env.NODE_ENV}`
    const database = `${settings.database}-${process.env.NODE_ENV}`
    const table = settings.table
    const destination = `${settings.destination}-${settings.icentris_client}`
    const systemSource = `system:s3://${bucket}/${database}`
    const botId = event.__cron.id

    let checkpoint = await this.bus.leo.bot.getCheckpoint(botId, systemSource)
    if (!checkpoint) {
      checkpoint = `${table}/${database}/${table}-0-0.json`
      Log.info(event.icentris_client, `Defaulting Checkpoint: ${checkpoint}`)
    }

    const stats = ls.stats(botId, systemSource)

    Log.info(event.icentris_client, `Bot Id: ${botId}`)
    Log.info(event.icentris_client, `Checkpoint: ${checkpoint}`)
    Log.info(event.icentris_client, `Bucket: ${bucket}`)
    Log.info(event.icentris_client, `Table: ${table}`)
    Log.info(event.icentris_client, `Database: ${database}`)
    Log.info(event.icentris_client, `Destination: ${destination}`)
    Log.info(event.icentris_client, `Source: ${systemSource}`)

    const reader = new stream.Readable({
      objectMode: true,
      read () { }
    })
    reader.push(checkpoint)

    Log.info(event.icentris_client, `Vibe CDC piping changes from binary log to queue: ${destination}`)

    return new Promise((resolve, reject) => {
      ls.pipe(
        reader,
        this.processMaxScale(bucket, database, table),
        this.updateCheckpoint(systemSource),
        stats,
        this.bus.leo.load(botId, destination, { useS3: this.useS3 }),
        (err) => {
          if (err) {
            reject(err)
          } else {
            stats.checkpoint(resolve)
          }
        }
      )
    })
  }

  processMaxScale (bucket, database, table) {
    console.log('Process Maxscale')
    return ls.through((chunk, cb) => {
      const dd = []
      const checkpoint = chunk.toString()
      let end
      const m = async () => {
        const params = {
          Bucket: bucket
        }
        const bucketList = await this.listObjects(params)
        const sorted = this.sortS3(bucketList, checkpoint, database, table)
        const p = new Promise((resolve, reject) => {
          let i = 0
          if (sorted.length > 0) {
            try {
              end = sorted[sorted.length - 1].fileName
              sorted.forEach(async parseFileData => {
                const params = {
                  Bucket: bucket,
                  Key: parseFileData.fileName
                }
                const s3Object = await this.getS3Object(params)
                s3Object.forEach(s => {
                  const mergedData = Object.assign(s, parseFileData)
                  dd.push(mergedData)
                })
                if (++i === sorted.length) resolve()
              })
            } catch (e) {
              reject(e)
            }
          } else {
            end = checkpoint
            resolve()
          }
        })
        await p
      }
      m().then(s => {
        cb(null, this.transformPayload(dd, checkpoint, end))
      }).catch(e => { console.log(e) })
    })
  }

  updateCheckpoint (systemSource) {
    return ls.through((chunk, cb) => {
      const event = {
        correlation_id: {
          source: systemSource,
          units: 1,
          start: chunk.start,
          end: chunk.end
        }
      }
      delete chunk.start
      delete chunk.end
      if (chunk.payload.length > 0) {
        cb(null, Object.assign(event, chunk))
      } else {
        // Cut off stream so we don't load Leo queue with empty data.
        cb(null, null)
      }
    })
  }

  log (ls, icentrisClient) {
    return ls.through((obj, done) => {
      Log.info(icentrisClient, `Writing to leo.load ${JSON.stringify(obj)}`)
      done(null, obj)
    })
  }

  sortS3 (bucketList, checkpointFile, database, table) {
    const checkpointFilePosition = this.getCheckpointFromFileName(checkpointFile, database, table)
    const filteredbucketList = this.filterJsonFiles(bucketList, database, table)
    const unorderedList = filteredbucketList.map(file => this.getCheckpointFromFileName(file, database, table))
    const s1 = unorderedList.sort((a, b) => {
      if (a.sequence < b.sequence) {
        return -1
      } else if (a.sequence > b.sequence) {
        return 1
      }
      if (a.event_id < b.event_id) {
        return -1
      } else if (a.event_id > b.event_id) {
        return 1
      }
      return 0
    })
    const filteredFiles = s1.filter(a => {
      if (checkpointFilePosition.sequence === a.sequence) {
        return a.event_id > checkpointFilePosition.event_id
      }
      return true
    })
    return filteredFiles
  }

  getCheckpointFromFileName (fileName, database, table) {
    const fileSplit = fileName.split('/')
    const checkpoint = fileSplit[2]
      .replace(`${fileSplit[0]}-`, '')
      .replace('.json', '')
    const splits = checkpoint.split('-')
    return {
      sequence: parseInt(splits[0]),
      event_id: parseInt(splits[1]),
      fileName: fileName,
      database: database,
      table: table
    }
  }

  async listObjects (params) {
    const s3 = this.getS3()
    const data = await s3.listObjectsV2(params).promise()
    const contents = data.Contents.map(s => { return s.Key })
    return contents
  }

  async getS3Object (params) {
    const s3 = this.getS3()
    const data = await s3.getObject(params).promise()
    // place ndjson here
    return this.convertNdjson(data.Body.toString('utf-8'))
  }

  filterJsonFiles (s3BucketList, database, table) {
    return s3BucketList
      .filter(s => s.indexOf('.json') > -1)
      .filter(s => s.startsWith(`${table}/${database}`))
  }

  getS3 () {
    return ls.s3
  }

  transformPayload (s, start, end) {
    const grp = utils.groupBy(s, 'event_type')
    const formattedPayload = Object.keys(grp).map(g => {
      const payload = {}
      grp[g].forEach(ss => {
        if (!payload[ss.event_type]) payload[ss.event_type] = {}
        if (!payload[ss.event_type][ss.database]) payload[ss.event_type][ss.database] = {}
        if (!payload[ss.event_type][ss.database][ss.table]) payload[ss.event_type][ss.database][ss.table] = new Set() // remove dups
        payload[ss.event_type][ss.database][ss.table].add(ss.id)
      })
      // Convert `set` back to `array`. JSON Stringify cannot stringify sets.
      // https://medium.com/dailyjs/how-to-remove-array-duplicates-in-es6-5daa8789641c
      grp[g].forEach(ss => { payload[ss.event_type][ss.database][ss.table] = [...payload[ss.event_type][ss.database][ss.table]]})

      return payload
    })
    return {
      payload: formattedPayload,
      start: start,
      end: end
    }
  }

  convertNdjson (s) {
    const jsonRows = s.split(/\n|\n\r/).filter(Boolean)
    return jsonRows.map(jsonStringRow => JSON.parse(jsonStringRow))
  }
}

module.exports = new LoadMaxscaleCDCBot()
