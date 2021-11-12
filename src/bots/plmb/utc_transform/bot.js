'use strict'

const Bot = require('../../bot')
const utils = require('../../../libs/utils')
const _timezones = require('./timezones')

class UTCTransform extends Bot {
  async handle (event, context) {
    super.handle(event, context)

    return this.transform(
      this.botId,
      event.source,
      event.destination,
      (payload, meta, done) => {
        this.each(payload)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null)
            }
          })
          .catch(err => {
            done(err)
          })
      }
    )
  }

  async each (payload) {
    const client = payload.icentris_client
    if (!client) return null
    const zone = this.getTimezone(client)

    const dateTest = key => /.+_date$/.test(key)
    const dateToUTC = date => utils.formatDateToUTC(date, zone)

    const transformSimpleNestedObjects = async (inObj) => {
      for (const [key, value] of Object.entries(inObj)) {
        if (value === null || value === undefined) continue
        if (typeof value === 'object') transformSimpleNestedObjects(value)
        else if (dateTest(key)) inObj[key] = dateToUTC(value)
      }
    }
    const outObj = JSON.parse(JSON.stringify(payload))
    return transformSimpleNestedObjects(outObj)
      .then(() => outObj)
      .catch(err => { throw err })
  }

  getTimezone (client) {
    return _timezones[client]
  }
}

module.exports = UTCTransform
