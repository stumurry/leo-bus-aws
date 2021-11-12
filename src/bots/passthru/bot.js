'use strict'

const Bot = require('../bot')

class PassThru extends Bot {
  async handle (event, context) {
    super.handle(event, context)

    return this.transform(
      event.botId,
      event.source,
      event.destination,
      (payload, meta, done) => {
        this.each(payload)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null, true)
            }
          })
          .catch(err => {
            done(err)
          })
      }
    )
  }

  async each (payload) {
    return Object.assign({}, payload)
  }
}

module.exports = PassThru
