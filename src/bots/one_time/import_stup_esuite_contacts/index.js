
'use strict'

const Bot = require('../../bot')
// const fs = require('fs')
const fastCsv = require('fast-csv')

class ImportEsuiteContactsFromS3 extends Bot {
  async handle (event, context) {
    super.handle(event, context)

    const { file } = event
    const bucket = `icentris-bus-${process.env.NODE_ENV}`
    const fullFilePath = `miscellaneous/${file}`

    const ls = this.bus.leo.streams
    return new Promise((resolve, reject) => {
      const botId = this.botId
      const { destination } = event

      const opts = {
        headers: {},
        ignoreEmpty: true,
        trim: true,
        escape: '\\',
        quote: '\\',
        nullValue: '\\N'
      }
      ls.pipe(ls.fromS3({ bucket: bucket, key: `${fullFilePath}` }),
        fastCsv.parse(opts),
        ls.load(botId, destination), err => {
          if (err) {
            reject(err)
          } else {
            resolve()
          }
        })
    })

    // // leo-cli test
    // return new Promise((resolve, reject) => {
    //   let leo = require('leo-sdk')
    //   const ls = leo.streams
    //   let botId = this.botId // ImportStupEsuiteContactsFromS3
    //   let queueName = 'stup-new-esuite-contacts'
    //   const opts = {
    //     headers: {},
    //     ignoreEmpty: true,
    //     trim: true,
    //     escape: '\\',
    //     quote: '\\',
    //     nullValue: '\\N'
    //   }
    //   ls.pipe(
    //     fs.createReadStream('./Content.csv'),
    //     fastCsv.parse(opts),
    //     ls.load(botId, queueName),
    //     err => {
    //       if (err) {
    //         reject(err)
    //       } else {
    //         resolve()
    //       }
    //     })
    // })
  }
}
module.exports = new ImportEsuiteContactsFromS3()
