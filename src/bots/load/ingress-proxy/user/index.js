'use strict'

const IngressLoaderBot = require('../bot')

class LoadIngressProxyUserBot extends IngressLoaderBot {
  async each (payload) {
    if (payload.rank) {
      Object.assign(payload, { rank: { client_level: payload.rank.id, name: payload.rank.description } })
    }

    if (process.env.NODE_ENV === 'tst') {
      Object.assign(payload, { email: 'icentris.qa6+' + payload.client_user_id + '@gmail.com', home_phone: '1111111111', mobile_phone: '1111111111' })
    }
    return Object.assign({}, payload)
  }
}

module.exports = new LoadIngressProxyUserBot()
