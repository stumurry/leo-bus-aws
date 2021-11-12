'use strict'

const VibeOffloadBot = require('../bot')

const tableMaps = {
  orders: require('./orders.json'),
  order_items: require('./order_items.json')
}
class OrderOffloadBot extends VibeOffloadBot {
  async each (payload) {
    const db = await this.getVibeDB(payload.icentris_client)

    const order = this.translate(this.getClientMap(tableMaps.orders, payload.client_code), payload)

    if (payload.tracking_numbers) {
      payload.tracking_numbers.map((n, k) => {
        if (k === 0) {
          k = ''
        } else {
          k = `_${k}`
        }

        order['tracking_number' + k] = n
      })
    }

    await db.upsert('tree_orders', order, 'id')

    if (payload.items) {
      return this.bus.Promise.map(payload.items, item => {
        item.order_id = order.id
        if (!item.order_item_id) {
          item.order_item_id = 0
        }

        item = this.translate(this.getClientMap(tableMaps.order_items), item)

        return db.upsert('tree_order_items', item, ['order_id', 'product_code'], 'id')
      }, { concurrency: 5 })
    } else {
      return Promise.resolve()
    }
  }
}

module.exports = new OrderOffloadBot()
