'use strict'

const VibeOffloadBot = require('../bot')

const map = require('./tree_period_data')

class TreePeriodDataOffloadBot extends VibeOffloadBot {
  async each (payload, meta) {
    // skip if period is defined or if there is no client map
    if (payload.period_id && payload.period_id !== 'current' && payload.icentris_client in map) {
      const str = await this.getTableWriteStream(payload.icentris_client, 'tree_period_data')
      const record = this.translate(this.getClientMap(map, payload.icentris_client), payload)
      str.write({ record: record, eid: meta.eid })
    }
  }
}

module.exports = new TreePeriodDataOffloadBot()
