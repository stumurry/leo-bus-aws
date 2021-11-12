'use strict'

const VibeOffloadBot = require('../bot')

const maps = {
  tree_user_plus: require('./tree_user_plus.json')
}

class TreeUserPlusOffloadBot extends VibeOffloadBot {
  async each (payload, meta) {
    // skip if period is defined or if there is no client map -- ndg 9/17/2018
    if ((payload.period_id && payload.period_id !== 'current') || !(payload.icentris_client in maps.tree_user_plus)) {
      return
    }

    const str = await this.getTableWriteStream(payload.icentris_client, 'tree_user_plus')
    const record = this.translate(this.getClientMap(maps.tree_user_plus, payload.icentris_client), payload)
    str.write({ record: record, eid: meta.eid })
  }
}

module.exports = new TreeUserPlusOffloadBot()
