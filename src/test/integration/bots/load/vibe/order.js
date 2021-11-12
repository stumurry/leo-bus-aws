'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'tree_orders'
    await opts.mysql.truncate(opts.event.table)

    const orders = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([{
        id: 1,
        tree_user_id: 1,
        order_type_id: 1,
        order_status_id: 1,
        autoship_template_id: null,
        order_date: '2019-12-24 23:59:59',
        currency_code: 'USD',
        total: 116.00,
        sub_total: 100.00,
        tax_total: 6.00,
        shipping_total: 10.00,
        bv_total: 20,
        cv_total: 20,
        discount_total: 0,
        discount_code: null,
        timezone: 'MDT',
        shipped_date: '2020-01-01 9:00:00',
        shipping_city: 'Whoville',
        shipping_state: 'MT',
        shipping_zip: '12345',
        shipping_country: 'US',
        shipping_county: null,
        tracking_number: null,
        created_date: '2019-12-24 23:59:59',
        modified_date: '2020-01-01 8:59:00',
        client_order_id: 1,
        client_user_id: '00001'
      }, {
        id: 2,
        tree_user_id: 2,
        order_type_id: 2,
        order_status_id: 1,
        autoship_template_id: null,
        order_date: '2019-11-20 23:59:59',
        currency_code: 'USD',
        total: 106.00,
        sub_total: 100.00,
        tax_total: 6.00,
        shipping_total: 10.00,
        bv_total: 20,
        cv_total: 20,
        discount_total: 10.00,
        discount_code: 'freeshipping',
        timezone: 'MDT',
        shipped_date: '2019-11-30 9:00:00',
        shipping_city: 'Whoville',
        shipping_state: 'MT',
        shipping_zip: '12345',
        shipping_country: 'US',
        shipping_county: null,
        tracking_number: 'z123451234512345',
        created_date: '2019-12-24 23:59:59',
        modified_date: '2020-01-01 8:59:00',
        client_order_id: 2,
        client_user_id: '00002'
      }])
      .toString()

    await opts.mysql.execute(orders)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          tree_orders: [1, 2]
        }
      },
      delete: { 'pyr-bluesun-local': { tree_orders: [3] } }
    }]
  })

  describe('#handle', () => {
    it('should load the domain objects for ids 1, 2', async () => {
      await bot.handle(opts.event, opts.context)

      assert(opts.bus.outQueueData.length === 2)

      const ids = opts.bus.outQueueData.map(o => {
        const p = o.payload

        assert(Object.keys(p).length > 0)
        assert.strictEqual(p.icentris_client, 'bluesun')
        return o.domain_id
      })
      assert.deepEqual([1, 2], ids)
    })
  })
}
