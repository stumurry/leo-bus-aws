'use strict'

const moment = require('moment')
const eventStream = require('event-stream')
const fs = require('fs')

module.exports = {
  mock: function (bus) {
    bus.outQueueData = []
    bus.inQueueData = []

    const streams = bus.leo.streams
    streams.bus = bus
    this.fromLeo = streams.fromLeo
    streams.fromLeo = function (ID, queue, opts) {
      if (!queue) {
        throw new Error('Missing queue arg!')
      }

      return eventStream.readArray(this.bus.inQueueData.map(obj => {
        const event = obj.payload ? obj : { payload: obj }

        event.id = ID
        event.eid = 'z/' + moment.now()
        event.event = queue
        if (!event.event_source_timestamp) {
          event.event_source_timestamp = moment.now()
        }
        if (!event.timestamp) {
          event.timestamp = moment.now()
        }

        return event
      }))
    }

    this.toLeo = streams.toLeo
    streams.toLeo = function () {
      return bus.leo.streams.through((obj, done) => {
        this.bus.outQueueData.push(obj)
        done(null, Object.assign({
          correlations: [],
          id: 'correlated_id'
        }, obj))
      })
    }

    this.toDynamoDB = streams.toDynamoDB
    streams.toDynamoDB = function (table, opts) {
      if (!opts) {
        throw new TypeError('Cannot read property hash of undefined')
      }

      if (!opts.hash) {
        throw new Error('Missing hash in opt')
      }

      if (!table) {
        throw new Error('table missing')
      }

      return bus.leo.streams.through((obj, done) => {
        if (Object.keys(obj).length === 0) {
          done(new Error('Missing table fields'))
        } else {
          // write obj to AWS
          this.bus.outQueueData.push(obj)
          done(null)
        }
      })
    }

    this.fromS3 = streams.fromS3
    streams.fromS3 = (file, opts) => {
      return fs.createReadStream(`${process.cwd()}/test/mocks/${file.bucket}/${file.key}`)
    }

    this.toS3 = streams.toS3
    streams.toS3 = function (bucket, file) {
      const path = `${process.cwd()}/test/mocks/`
      return fs.createWriteStream(`${path}${bucket}/${file}`)
    }

    /**
     * @summary BEGIN Leo Supplied Mocks. They work. Don't ask how or why.
     * @author Noah Goodrich by way of Steve Lyon
     * @date 7/23/2018
     */
    this.cron = {}
    this.cron.checkpoint = streams.cron.checkpoint
    streams.cron.checkpoint = function (id, event, params, callback) {
      callback()
    }

    this.cron.createLock = streams.cron.createLock
    this.cron.checkLock = streams.cron.checkLock
    streams.cron.createLock = streams.cron.checkLock = function () {
      arguments[Object.keys(arguments).reverse().filter(f => typeof arguments[f] === 'function')[0]]()
    }

    this.cron.removeLock = streams.cron.removeLock
    this.cron.reportComplete = streams.cron.reportComplete
    streams.cron.removeLock = streams.cron.reportComplete = function () {
      arguments[Object.keys(arguments).reverse().filter(f => typeof arguments[f] === 'function')[0]]()
    }
    /**
     * @summary END Leo Supplied Mocks. They work. Don't ask how or why.
     * @author Noah Goodrich by way of Steve Lyon
     * @date 7/23/2018
     */
  },
  unmock: function (bus) {
    const streams = bus.leo.streams

    streams.toLeo = this.toLeo
    streams.fromLeo = this.fromLeo
    streams.toDynamoDB = this.toDynamoDB
    streams.fromS3 = this.fromS3
    streams.toS3 = this.toS3
    streams.cron.checkpoint = this.cron.checkpoint
    streams.cron.createLock = this.cron.createLock
    streams.cron.checkLock = this.cron.checkLock
    streams.cron.removeLock = this.cron.removeLock
    streams.cron.reportLock = this.cron.reportLock

    delete bus.inQueueData
    delete bus.outQueueData
  }
}
