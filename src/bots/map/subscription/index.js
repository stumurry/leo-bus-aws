'use strict'

const MapBot = require('../bot')

class SubscriptionBot extends MapBot {
  async fetchUser (client, treeUserId, ticker = 4) {
    const db = await this.getVibeDB(client)

    const select = db.squel.select()
      .field('id')
      .from('users')
      .where('tree_user_id = ?', treeUserId)
      .toParam()

    return db.execute(select.text, select.values)
      .then(rs => {
        rs = rs[0]
        if (rs.length > 0) {
          return rs[0].id
        } else {
          if (ticker > 0) {
            return new Promise((resolve, reject) => {
              setTimeout(() => {
                resolve()
              }, Math.abs(3 - ticker) * 1000)
            }).then(() => {
              return this.fetchUser(client, treeUserId, --ticker)
            })
          } else {
            throw new Error('User record not found!')
          }
        }
      })
  }

  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        return this.bus.Promise.all([
          mapper.treeUserId(payload.client_user_id),
          mapper.lookupId({ name: payload.subscription_plan.name }, {
            lookupField: 'name',
            primaryKeyField: 'id',
            tbl: 'pyr_subscription_plans'
          })
        ])
      })
      .then(([treeUserId, planId]) => {
        return Promise.all([this.fetchUser(payload.icentris_client, treeUserId), treeUserId, planId])
      })
      .then(([userId, treeUserId, planId]) => {
        return Object.assign(payload, {
          user_id: userId,
          tree_user_id: treeUserId,
          subscription_plan_id: planId,
          subscription_plan: Object.assign(payload.subscription_plan, { id: planId })
        })
      })
  }
}

module.exports = new SubscriptionBot()
