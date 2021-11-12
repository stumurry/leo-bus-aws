'use strict'

const MapBot = require('../bot')

class SummaryDataBot extends MapBot {
  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        const promises = {}
        promises.tree_user_id = mapper.treeUserId(payload.client_user_id)
        if (payload.period) promises.period_id = mapper.period(payload.period)
        if (payload.rank) promises.rank_id = mapper.rankId(payload.rank)
        if (payload.paid_rank) promises.paid_rank_id = mapper.rankId(payload.paid_rank)
        return this.bus.Promise.props(promises)
      })
      .then(rs => {
        // Extract any field(s) needed in the root object
        if (payload.period) Object.assign(rs, { period_type_id: payload.period.period_type_id })
        return Object.assign(payload, rs)
      })
  }
}

module.exports = new SummaryDataBot()
