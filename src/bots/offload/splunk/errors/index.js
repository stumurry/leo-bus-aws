'use strict'

// const maxBatchCount = 10
const Bot = require('../../../bot')
// const SplunkLogger = require('splunk-logging').Logger
// const Log = require('../../../../libs/log')

class OffloadSplunkErrors extends Bot {
  /* async flush (force = false) {
    if (maxBatchCount === this.logger.serializedContextQueue.length || force) {
      return new this.bus.Promise((resolve, reject) => {
        this.logger.flush((err, resp, body) => {
          if (err) reject(err)
          else resolve(body)
        })
      })
    }

    return this.bus.Promise.resolve()
  } */

  /* async each (payload, meta) {
    Log.debug(payload.client, payload.error.message, { data: payload })

    const obj = {
      oid: payload.client,
      tid: payload.eventId,
      type: payload.type,
      msg: payload.error.message
    }

    this.logger.send({
      message: obj,
      metadata: {
        source: 'DataBus' + payload.event.botId,
        sourcetype: '_json'
      },
      severity: 'error'
    })

    return this.flush()
  }

  async handle (event, context) {
    super.handle(event, context)

    const splunkConfig = await this.getReflexConfig().then(cfg => {
      return Object.assign(cfg.splunk, {
        maxBatchCount: 0,
        level: 'error'
      })
    })

    this.logger = new SplunkLogger(splunkConfig)

    return this.bus.offload(this.botId, event.source, async (payload, meta, done) => {
      return this.each(payload, meta)
        .then(() => {
          return this.flush(true)
        })
    })
  } */
}

module.exports = new OffloadSplunkErrors()
