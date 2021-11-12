'use strict'

const s3 = require('../../libs/s3')
const fs = require('fs')
const { pipeline } = require('stream')

module.exports = {
  mock: () => {
    this.rename = s3.rename
    s3.rename = (bucket, oldKey, newKey) => {
      const path = `${process.cwd()}/test/mocks/`
      return new Promise((resolve, reject) => {
        const older = `${path}${bucket}/${oldKey}`
        const newer = `${path}${bucket}/${newKey}`
        if (fs.existsSync(older) && fs.statSync(older).size > 0) {
          fs.rename(older, newer, (err) => {
            if (err) {
              reject(err)
            } else {
              resolve(true)
            }
          })
        } else {
          resolve(false)
        }
      })
    }

    this.upload = s3.upload
    s3.upload = (params) => {
      return {
        promise: () => {
          return new Promise((resolve, reject) => {
            const path = `${process.cwd()}/test/mocks/${params.Bucket}/${params.Key}`
            const ws = fs.createWriteStream(path)
            pipeline(
              params.Body,
              ws,
              (err) => {
                if (err) {
                  console.error('Pipeline failed', err)
                  reject(err)
                } else {
                  console.log('Pipeline succeeded')
                  resolve()
                }
              }
            )
          })
        }
      }
    }
  },
  unmock: () => {
    s3.rename = this.rename
    delete this.rename
    s3.upload = this.upload
    delete this.upload
  }
}
