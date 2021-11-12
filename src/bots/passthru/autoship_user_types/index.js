'use strict'

const PassThruBot = require('../bot')

class PassThruAutoshipUserTypesBot extends PassThruBot {
  async each (payload) {
    if (payload.autoship_template && payload.autoship_template.id > 0) {
      const outObj = {
        icentris_client: payload.icentris_client,
        tree_user_id: payload.tree_user_id,
        autoship_template_id: parseInt(payload.autoship_template.id),
        order_date: payload.order_date
      }
      return outObj
    }
    return null
  }
}

module.exports = new PassThruAutoshipUserTypesBot()
