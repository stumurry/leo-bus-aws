'use strict'

const Mapper = require('../../../../../bots/map/mapper')
const moment = require('moment')

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async function () {
    this.timeout(21000)

    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await opts.mysql.execute('TRUNCATE TABLE tree_orders')
    await opts.mysql.execute('TRUNCATE TABLE tree_order_items')
    await opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')

    const mapper = new Mapper(opts.mysql)
    const treeUserId = await mapper.treeUserId(1)
    await opts.mysql.execute('INSERT INTO tree_order_statuses (id, description) VALUES (3, \'Testing\')')

    opts = opts.setOptsForBot('offload/vibe/orders', opts)

    const events = [{
      icentris_client: 'bluesun',
      order_id: 1,
      client_user_id: 1,
      tree_user_id: treeUserId,
      order_date: moment().format('YYYY-MM-DD HH:mm:ss'),
      status_id: 3,
      status: {
        id: 3,
        description: 'Testing'
      },
      personal_volume: 500,
      commission_volume: 400,
      items: [{
        sku: 'sku1234',
        name: 'Widget 1',
        description: 'Another brick in the wall',
        quantity: 2,
        unit_price: 70,
        total_price: 140,
        unit_volume: 250,
        total_volume: 500,
        unit_commission_volume: 200,
        total_commission_volume: 400
      }]
    }]

    opts.setCheckpointsToCurrent(opts)

    return opts.bootstrapSource(opts, events)
  })

  it.skip('should read from the orders queue and write to the tree_orders table', function (done) {
    this.timeout(5000)

    opts.bot.handler(opts.event, opts.createContext(), (err, _) => {
      if (err) done(err)
      else {
        opts.mysql.execute('SELECT * FROM tree_orders WHERE id = 1')
          .then(rs => {
            const row = rs[0][0]

            assert.equal(row.id, 1)
            assert.equal(row.order_status_id, 3)
            assert.equal(parseFloat(row.cv_total), parseFloat(400))

            return opts.mysql.execute('SELECT * FROM tree_order_items WHERE order_id = 1')
          })
          .then(rs => {
            const rows = rs[0]

            assert.equal(rows.length, 1)
            assert.equal(rows[0].product_code, 'sku1234')
            assert.equal(rows[0].quantity, 2)

            done()
          })
          .catch(done)
      }
    })
  })
}
