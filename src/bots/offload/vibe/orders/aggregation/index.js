'use strict'

const VibeOffloadBot = require('../../bot')
const utils = require('../../../../../libs/utils')

class OrderAggregationBot extends VibeOffloadBot {
  async each (payload) {
    if ([null, '', 0, undefined].indexOf(payload.tree_user_id) > -1) {
      throw new Error(`payload.tree_user_id has an invalid value: '${payload.tree_user_id}'`)
    }

    const db = await this.getVibeDB(payload.icentris_client)

    const lastOrderId = payload.order_id
    const orderDate = utils.formatDate(payload.order_date)
    const lastOrderTotal = payload.total

    const insert = `
      UPDATE
        tree_user_plus
      SET
        last_order_id = '${lastOrderId}',
        last_order_date = '${orderDate}',
        last_order_total = '${lastOrderTotal}'
      WHERE
        tree_user_id = ${payload.tree_user_id}
        AND (last_order_date IS NULL OR last_order_date < '${orderDate}')
    `
    return db.execute(insert)
  }
}

module.exports = new OrderAggregationBot()
