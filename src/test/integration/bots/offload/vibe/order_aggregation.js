'use strict'
const utils = require('../../../../../libs/utils')

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(() => {
    bot = opts.getBot('offload/vibe/orders/aggregation')
  })

  describe('#handle', async function () {
    beforeEach(async () => {
      await opts.mysql.truncate('tree_users')
      await opts.mysql.truncate('tree_user_plus')

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        order_id: 456,
        tree_user_id: 1,
        status_id: 1,
        client_user_id: 'd1234',
        order_date: '2018-01-01 04:50:02',
        status: {
          id: '1',
          description: 'In Progress'
        },
        total: '70.00',
        personal_volume: '100',
        commission_volume: '60',
        autoship_template_id: 1,
        autoship_template: {
          id: '1',
          next_run_date: '2018-02-01 08:00:00',
          status: {
            id: '1',
            description: 'Active'
          }
        },
        items: [{
          sku: 'sku1234',
          name: 'Widget 1',
          description: 'Does something',
          quantity: '2',
          unit_price: '35.00',
          total_price: '70.00',
          unit_volume: '10',
          unit_commission_volume: '7',
          total_volume: '20',
          total_commission_volume: '14'
        }]
      }]

      opts.bus.inQueueData.forEach(async (order) => {
        await opts.mysql.execute(`INSERT INTO tree_user_plus(tree_user_id, client_user_id) values('${order.tree_user_id}', '${order.client_user_id}')`)
        await opts.mysql.execute(`INSERT INTO tree_users(id, client_user_id) values('${order.tree_user_id}', '${order.client_user_id}')`)
      })
    })

    it('should update last_order_date if tree_user_plus.last_order_date IS NULL', async function () {
      // Ensure last_order_date IS NULL
      const beforeRs = await opts.mysql.execute(`SELECT last_order_date from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      if (beforeRs) {
        assert.equal(beforeRs.last_order_date, null)
      }

      await bot.handle(opts.event, opts.context)

      // Ensure last_order_date was updated
      const afterRs = await opts.mysql.execute(`SELECT last_order_id, last_order_date, last_order_total from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(afterRs.last_order_id, opts.bus.inQueueData[0].order_id)
      assert.ok(afterRs.last_order_date)
      assert.equal(Number.parseFloat(afterRs.last_order_total).toFixed(2), opts.bus.inQueueData[0].total)
    })

    it('should update last_order_date if tree_user_plus.last_order_date is < payload.order_date', async function () {
      // Set past date
      const pastDate = '1778-07-04 00:00:00'
      await opts.mysql.execute(`UPDATE tree_user_plus SET last_order_date = '${pastDate}' WHERE tree_user_id = ${opts.bus.inQueueData[0].tree_user_id}`)

      // Ensure past date was set
      const beforeRs = await opts.mysql.execute(`SELECT last_order_date from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(pastDate, utils.formatDate(beforeRs.last_order_date))

      await bot.handle(opts.event, opts.context)

      // Ensure last_order_date was updated
      const afterRs = await opts.mysql.execute(`SELECT last_order_id, last_order_date, last_order_total from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(afterRs.last_order_id, opts.bus.inQueueData[0].order_id)
      assert.equal(utils.formatDate(afterRs.last_order_date), opts.bus.inQueueData[0].order_date)
      assert.equal(Number.parseFloat(afterRs.last_order_total).toFixed(2), opts.bus.inQueueData[0].total)
    })

    it('should not update last_order_date if tree_user_plus.last_order_date is > payload.order_date', async function () {
      // Set future date
      const futureDate = '2050-12-25 00:00:00'
      await opts.mysql.execute(`UPDATE tree_user_plus SET last_order_date = '${futureDate}' WHERE tree_user_id = ${opts.bus.inQueueData[0].tree_user_id}`)
      // Ensure future date was set
      const beforeRs = await opts.mysql.execute(`SELECT last_order_id, last_order_date, last_order_total from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(futureDate, utils.formatDate(beforeRs.last_order_date))

      await bot.handle(opts.event, opts.context)

      // Ensure last_order_date was not updated
      const afterRs = await opts.mysql.execute(`SELECT last_order_date from tree_user_plus WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(utils.formatDate(afterRs.last_order_date), futureDate)
    })
  })
}
