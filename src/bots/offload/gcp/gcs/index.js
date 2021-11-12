'use strict'

const Bot = require('../../../bot')
// Switch between the two for functional testing - Stu M. 4/15/20
// When the leo-cli copies the files to Lambda, the @google-cloud is chopped
// const { Storage } = require('@google-cloud/storage')
let storage
if (process.env.IS_TEST_ENV === 'YES') {
  storage = require('@google-cloud/storage')
} else {
  storage = require('storage')
}

const stream = require('stream')
const aws = require('aws-sdk')
const s3 = new aws.S3()
const util = require('util')

class GCSBot extends Bot {
  copyToGCS (ls, settings, stats) {
    return new stream.Writable({
      objectMode: true,
      write: async function (chunk, encoding, callback) {
        const bucket = chunk.payload.Bucket
        const key = chunk.payload.Key
        const gcsBucket = await settings.gcs_storage.bucket(settings.destination_gcs_bucket)
        const blob = gcsBucket.file(key)
        ls.pipe(
          s3.getObject({ Bucket: bucket, Key: key }).createReadStream(),
          blob.createWriteStream(),
          (err) => {
            if (!err) {
              console.log(`Done copying ${key}`)
              stats.checkpoint(callback)
            } else {
              console.log(err)
              callback(new Error(err))
            }
          })
      }
    })
  }

  async handle (event, context) {
    const leo = this.bus.leo
    const ls = leo.streams
    const settings = Object.assign({}, event)
    const botId = context.botId
    const queue = settings.queue
    // not really a local environment on gcp. - Stu M. 4/7/20
    const env = (process.env.NODE_ENV === 'local' || process.env.NODE_ENV === 'dev') ? 'dev' : process.env.NODE_ENV

    await this.getRemoteConfig().then(config => {
      settings.config = config
      settings.gcs_storage = new storage.Storage(settings.config.gcp)
      settings.destination_gcs_bucket = util.format(settings.destination_gcs_bucket, env)
    })

    return new Promise((resolve, reject) => {
      const stats = ls.stats(botId, queue)
      ls.pipe(
        ls.fromLeo(botId, queue),
        stats,
        this.copyToGCS(ls, settings, stats),
        (err) => {
          if (err) reject(err)
          else {
            console.log('-- end --')
            resolve()
          }
        })
    })
  }
}

module.exports = new GCSBot()
