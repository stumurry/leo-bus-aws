'use strict'

const MapBot = require('../bot')

class OrderBot extends MapBot {
  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        const promises = {}
        if (payload.client_user_id) promises.tree_user_id = mapper.treeUserId(payload.client_user_id)
        if (payload.status) {
          promises.status_id = mapper.lookupId(payload.status, {
            primaryKeyField: 'id',
            lookupField: 'id',
            tbl: 'tree_order_statuses'
          })
        }
        return this.bus.Promise.props(promises)
      })
      .then(rs => {
        return Object.assign(rs, payload)
      })
  }
}
module.exports = new OrderBot()
