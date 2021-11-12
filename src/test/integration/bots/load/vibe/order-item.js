'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'tree_order_items'
    await opts.mysql.truncate(opts.event.table)

    const orderItems = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([
        {
          order_item_id: 1,
          order_id: 1,
          product_id: 1,
          product_code: 'P-12345',
          product_description: 'Widget Kit',
          quantity: 1,
          price_each: 100,
          price_total: 100,
          weight_each: 1,
          weight_total: 1,
          tax: 6,
          bv: 20,
          bv_each: 20,
          cv_each: 20,
          cv: 20
        },
        {
          order_item_id: 2,
          order_id: 1,
          product_id: 1,
          product_code: 'P-54321',
          product_description: 'Reverse Widget Kit',
          quantity: 1,
          price_each: 100,
          price_total: 100,
          weight_each: 1,
          weight_total: 1,
          tax: 6,
          bv: 20,
          bv_each: 20,
          cv_each: 20,
          cv: 20
        }
      ])
      .toString()

    await opts.mysql.execute(orderItems)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          tree_order_items: [1, 2]
        }
      },
      delete: { 'pyr-bluesun-local': { tree_order_items: [3] } }
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
