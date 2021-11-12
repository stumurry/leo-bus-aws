'use strict'

const MapBot = require('../bot')

class MapTreeNodeBot extends MapBot {
  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        const promises = {}
        promises.tree_user_id = mapper.treeUserId(payload.client_user_id)
        if (payload.client_upline_id && payload.type === 'placements') promises.upline_id = mapper.parentId({ client_parent_id: payload.client_upline_id })
        if (payload.client_upline_id && payload.type === 'sponsors') promises.upline_id = mapper.sponsorId({ client_sponsor_id: payload.client_upline_id })
        return this.bus.Promise.props(promises)
      })
      .then(rs => {
        return Object.assign(payload, rs)
      })
  }
}

module.exports = new MapTreeNodeBot()
