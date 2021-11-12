'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  let bot
  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')
    await opts.mysql.execute('TRUNCATE TABLE tree_users')

    bot = opts.getBot('map/order')
  })

  describe('#handle', function () {
    it('should add an auto_incremented tree_user_id and status_id equal to that provided by the client payload to the object payload', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        client_user_id: 1,
        order_date: '2018-01-01 10:04:30',
        status: {
          id: 5,
          description: 'Ready'
        },
        total: 450
      }, {
        icentris_client: 'bluesun',
        client_user_id: 4,
        order_date: '2018-01-01 10:04:35',
        status: {
          id: 2,
          description: 'Pending'
        },
        total: 500
      }]

      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const order0 = opts.bus.outQueueData[0].payload
      const order1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(order0.client_user_id, 1)
      assert.strictEqual(order0.tree_user_id, 1)
      assert.strictEqual(order0.status_id, 5)

      assert.strictEqual(order1.client_user_id, 4)
      assert.strictEqual(order1.tree_user_id, 2)
      assert.strictEqual(order1.status_id, 2)
    })

    it('should not fail when only order_id and tracking_numbers is passed', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        order_id: 3456,
        tracking_numbers: [
          'tracking_1',
          'tracking_2'
        ]
      }]

      await bot.handle(opts.event, opts.context)

      const data = opts.bus.outQueueData
      assert.strictEqual(data.length, 1)

      assert.equal(data[0].payload.order_id, 3456)
      assert(!('tree_user_id' in data[0].payload))
      assert(!('status_id' in data[0].payload))
    })
  })
}
