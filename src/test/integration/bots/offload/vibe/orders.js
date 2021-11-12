'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/orders')
  })

  describe('#handle', async function () {
    beforeEach(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_users')
      await opts.mysql.execute('TRUNCATE TABLE tree_order_items')
      await opts.mysql.execute('TRUNCATE TABLE tree_orders')

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
        autoship_template: {
          id: 1,
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
      }, {
        icentris_client: 'bluesun',
        order_id: 457,
        tree_user_id: 1,
        status_id: 2,
        client_user_id: 'd1234',
        order_date: '2018-01-01 04:50:30',
        status: {
          id: '2',
          description: 'Started'
        },
        total: '130.00',
        personal_volume: '28',
        commission_volume: '18',
        autoship_template: {
          id: -1
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
        }, {
          sku: 'sku1235',
          name: 'Widget 2',
          description: 'Awesome!',
          quantity: '4',
          unit_price: '15.00',
          total_price: '60.00',
          unit_volume: '2',
          unit_commission_volume: '1',
          total_volume: '8',
          total_commission_volume: '4'
        }]
      }]
    })

    it('should write the orders records', async function () {
      await bot.handle(opts.event, opts.context)

      // leaving comment here  to assist with troubleshooting later
      // since errors are swallowed and piped to the outQueueData -- ndg 9/18/2018
      // console.log(opts.bus.outQueueData[0].payload)
      assert.equal(opts.bus.outQueueData.length, 0)

      return Promise.all(opts.bus.inQueueData.map(async (obj) => {
        let rs = await opts.mysql.execute('SELECT * FROM tree_orders WHERE id = ?', [obj.order_id])
        rs = rs[0]
        assert.equal(rs.length, 1)

        rs = rs[0]
        assert.equal(rs.id, obj.order_id)
        assert.equal(rs.order_status_id, parseInt(obj.status_id))
        assert.equal(rs.order_type_id, obj.type_id === undefined ? null : obj.type_id)
        assert.equal(rs.autoship_template_id, obj.autoship_template.id)
      }))
    })

    it('should write the order_items records', async function () {
      await bot.handle(opts.event, opts.context)

      await Promise.all(opts.bus.inQueueData.map(async (obj) => {
        const rs = await opts.mysql.execute('SELECT * FROM tree_order_items WHERE order_id = ?', [obj.order_id]).then(rs => rs[0])

        assert.equal(rs.length, obj.items.length, `No Records found for OrderId: ${obj.order_id}`)

        obj.items.map((i, k) => {
          assert.equal(rs[k].product_code, i.sku)
          assert.equal(rs[k].product_description, i.name)
        })
      }))
    })

    it('should update the tracking_number field in the client vibe db without overwriting other data', async function () {
      let o = Object.assign({}, opts.bus.inQueueData[0])
      o = bot.translate(bot.getClientMap(require('../../../../../bots/offload/vibe/orders/orders.json'), o.client_code), o)

      const sql = opts.mysql.squel.insert()
        .into('tree_orders')
        .setFields(o)
        .toParam()

      await opts.mysql.execute(sql.text, sql.values)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        order_id: 456,
        tracking_numbers: [
          'z1234'
        ]
      }]

      const original = Object.assign({}, opts.bus.inQueueData[0])

      await bot.handle(opts.event, opts.context)

      const order = await opts.mysql.execute('SELECT * FROM tree_orders WHERE id = 456').then(rs => rs[0][0])

      assert.equal(order.tracking_number, original.tracking_numbers[0])

      assert.equal(parseFloat(order.cv_total), parseFloat(o.cv_total))
      assert.equal(parseFloat(order.total), parseFloat(o.total))
    })
  })
}
