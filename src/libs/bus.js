'use strict'

class Bus {
  constructor (opts) {
    this.leo = require('leo-sdk')
    this.Promise = require('bluebird')
  }

  getQueue (queue) {
    return `${queue}`
  }

  offload (eventId, inQueue, each) {
    const offload = this.Promise.promisify(this.leo.offload)

    const opts = {
      id: eventId,
      queue: this.getQueue(inQueue),
      each
    }
    return offload(opts)
  }

  offloadToEndpoint (eventId, inQueue, request, each) {
    const queue = this.getQueue(inQueue)
    const ls = this.leo.streams
    // Gather stats of events we are processing to checkpoint later - slyon 7/21/2018
    const stats = ls.stats(eventId, queue)
    return new Promise((resolve, reject) => {
      // Read from Leo for ID, QUEUE - slyon 7/21/2018
      ls.pipe(ls.fromLeo(eventId, queue, {
        limit: 10
        // ls.stringify turns it into  json newline delimited - slyon 7/21/2018
        // ls.write allows us to end the stream and forward it to the request - slyon 7/21/2018
      }), stats, ls.through(each), ls.stringify(), ls.write((line, done) => {
        // write to a pipe that should be going to a webserver - slyon 7/21/2018
        if (!request.write(line)) {
          // the webserver is telling us to slow down - slyon 7/21/2018
          request.once('drain', done)
        } else {
          done()
        }
      }), err => {
        if (err) {
          return reject(err) // error so reject the promise - ndg 7/22/2018
        }
        request.once('end', (err) => {
          if (err) {
            return reject(err) // error so reject the promise - ndg 7/22/2018
          }
          // Everything is good, so let's checkpoint these events - slyon 7/21/2018
          stats.checkpoint(resolve)
        })
        // we need to end the request - slyon 7/21/2018
        request.end()
      })
    })
  }

  writeError (client, eventId, event, err, payload) {
    const obj = {
      client: client,
      eventId: eventId,
      event: event,
      type: 'error',
      msg: err.message,
      error: err,
      data: payload
    }

    this.getErrorStream(event.botId).write(obj)
  }

  getErrorStream (botId) {
    if (!this.errorStream) {
      this.errorStream = this.leo.load(botId, this.getQueue('errors'))
    }

    return this.errorStream
  }

  async endErrorStream () {
    if (!this.errorStream) {
      return Promise.resolve()
    }

    return new Promise((resolve, reject) => {
      this.errorStream.end(err => {
        if (err) {
          reject(err)
        } else {
          delete this.errorStream
          resolve()
        }
      })
    })
  }
}

module.exports = Bus
