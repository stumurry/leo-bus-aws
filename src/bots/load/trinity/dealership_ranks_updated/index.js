'use strict'

const Bot = require('../bot')

class DealershipRanksUpdatedBot extends Bot {
  async handle (event, context) {
    this.botId = event.botId || context.botId

    const settings = Object.assign({}, event)

    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(settings.destination))

    return this.bus.offload(this.botId, settings.source, (payload, meta, done) => {
      payload.changes.map(d => {
        let obj = {}
        obj = this.rankReducer('rank', d, obj)
        obj = this.dealershipIdReducer('dealership_id', d, obj)

        Object.assign(obj, {
          _event: payload._event,
          icentris_client: payload.icentris_client
        })

        stream.write(obj)
      })

      done(null, true)
    }).then(() => {
      return new Promise((resolve, reject) => {
        stream.end(err => {
          if (err) {
            reject(err)
          } else {
            delete this.errorStream
            resolve(null, true)
          }
        })
      })
    })
  }
}

module.exports = new DealershipRanksUpdatedBot()
