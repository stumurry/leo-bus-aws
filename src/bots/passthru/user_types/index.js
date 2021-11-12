'use strict'

const PassThruBot = require('../bot')

class PassThruUserTypesBot extends PassThruBot {
  async each (payload) {
    const outObj = {
      icentris_client: payload.icentris_client,
      tree_user_id: payload.tree_user_id,
      type_id: payload.type_id
    }
    return outObj
  }
}

module.exports = new PassThruUserTypesBot()
