'use strict'

const Bot = require('../../bot')
const s3 = require('../../../libs/s3')
const zlib = require('zlib')
const crypto = require('crypto')
const fs = require('fs')

const IV_LENGTH = 16 // For AES, this is always 16

class S3Bot extends Bot {
  encrypt (text) {
    const iv = crypto.randomBytes(IV_LENGTH)
    const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(this.encryptionKey, 'base64'), iv)
    let encrypted = cipher.update(text)

    encrypted = Buffer.concat([encrypted, cipher.final()])

    return iv.toString('hex') + ':' + encrypted.toString('hex')
  }

  enrichForBigQuery (obj) {
    obj.payload.ingestion_timestamp = (new Date()).toString()
    obj.payload.leo_eid = obj.eid
    return obj
  }

  zip (checksum, payload) {
    return new Promise((resolve, reject) => {
      const str = JSON.stringify(payload)
      zlib.gzip(str, (err, gzip) => {
        if (err) {
          console.log('gzip error', err)
          throw new Error(err)
        }
        let encrypted = this.encrypt(gzip)
        checksum.write(encrypted)
        resolve(encrypted)
      })
    })
  }

  writeToFile (ls, file, checksum, maxRecords) {
    // This file may be created in a previous test.  Delete if exists.
    if (fs.existsSync(file)) {
      fs.unlinkSync(file)
    }
    let count = 0
    return ls.write(async (obj, done) => {
      let enriched = this.enrichForBigQuery(obj)
      let payload = enriched.payload
      let zipped = await this.zip(checksum, payload)
      fs.appendFileSync(file, `${zipped}\n`)
      if (++count < maxRecords) {
        done()
      } else {
        done('done')
      }
    })
  }

  async handle (event, context) {
    this.bucket = `icentris-gcp-${process.env.NODE_ENV}`
    const newFile = `/tmp/${event.queue}-new`
    const ls = this.bus.leo.streams
    const cfg = await this.getRemoteConfig()
    this.encryptionKey = cfg.bus.secrets.gcp
    this.checksum = crypto.createHash('sha256')
    this.checksum.setEncoding('hex')
    this.destination = event.destination
    this.botId = event.botId
    this.maxRecords = event.maxRecords || 1000000

    console.log('this.botId: ', this.botId)
    console.log('this.destination: ', this.destination)
    console.log('this.maxRecords ', this.maxRecords)

    return new Promise((resolve, reject) => {
      const stats = ls.stats(this.botId, event.queue)
      ls.pipe(
        ls.fromLeo(this.botId, event.queue),
        stats,
        this.writeToFile(ls, newFile, this.checksum, this.maxRecords),
        (err) => {
          this.checksum.end()
          if (err === 'done') {
            stats.checkpoint(resolve)
          } else if (err) {
            reject(err)
          } else {
            stats.checkpoint(resolve)
          }
        })
    }).then(() => {
      this.timestamp = Date.now()
      this.checksum = this.checksum.read()
      const key = `${event.queue}-final-${this.checksum}-${this.timestamp}`
      const finalFile = `/tmp/${key}`
      return new Promise(async (resolve, reject) => {
        if (fs.existsSync(newFile)) {
          fs.open(newFile, 'r', async (error, fd) => {
            if (error) reject(error)
            if (fs.fstatSync(fd).size > 0) {
              fs.renameSync(newFile, finalFile)
              console.log('Writing to S3')
              let isFileUploaded = await s3.uploadFile(this.bucket, key, finalFile)
              if (isFileUploaded) {
                console.log('Writing to queue')
                const stream = ls.load(this.botId, this.destination)
                stream.write({
                  Bucket: this.bucket,
                  Key: key
                })
                stream.end(err => {
                  if (!err) {
                    console.log(`File created and uploaded to bucket: ${this.bucket} Key: ${key}`)
                    resolve()
                  } else {
                    reject(err)
                  }
                })
              }
            } else {
              resolve()
            }
          })
        } else {
          console.log('no data')
          resolve()
        }
      })
    })
  }
}

module.exports = new S3Bot()
