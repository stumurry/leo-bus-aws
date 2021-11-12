'use strict'
const Bot = require('../../../bot')
const request = require('superagent')

class OffLoadVictorOpsBot extends Bot {
  async handle (event, context) {
    super.handle(event, context)

    this.victorOpsConfig = await this.getRemoteConfig().then(cfg => {
      return Object.assign(cfg.victor_ops, {})
    })

    return this.bus.offload(this.botId, event.source, async (payload, meta, done) => {
      return this.each(payload, meta)
    })
  }

  async each (payload) {
    return this.writeToVictorOps(payload)
      .then(res => {
        return res.body
      })
  }

  async writeToVictorOps (payload) {
    return request
      .post(this.victorOpsConfig.url)
      .send(this.victorOpsRequest(payload))
      .type('application/json')
  }

  victorOpsRequest (payload) {
    return JSON.stringify({
      message_type: 'CRITICAL',
      entity_id: payload.entity_id,
      entity_display_name: `Health Check Error - leo-bus-${process.env.NODE_ENV}`,
      state_message: payload.message
    })
  }
}

module.exports = new OffLoadVictorOpsBot()
