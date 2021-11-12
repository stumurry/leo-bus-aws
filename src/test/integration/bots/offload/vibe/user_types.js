'use strict'

const Mapper = require('../../../../../bots/map/mapper')
const utils = require('../../../../../libs/utils')
const customerTypes = require('../../../../../bots/offload/vibe/customer_types.json')

module.exports = (opts) => {
  const assert = opts.assert

  let mapper
  before(() => {
    mapper = new Mapper(opts.mysql)
  })

  let bot
  let types
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/user_types')
  })

  describe('#user_types', async function () {
    beforeEach(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_users')
      await opts.mysql.execute('TRUNCATE TABLE tree_orders')
      await mapper.treeUserId('1234')

      // re-assign in inside the it block if testing different clients
      types = Object.assign(customerTypes.default, 'bluesun')
    })

    it('should offload user_type_id for a distributor', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        type_id: types.distributor
      }]

      await bot.handle(opts.event, opts.context)
      const offloadQuery = 'SELECT user_type_id FROM tree_users WHERE tree_users.client_user_id in (1234)'
      const offloadedData = await opts.mysql.execute(offloadQuery)

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.distributor)
    })

    it('should upgrade user_type_id for a customer if db.order_date within 31 days', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        type_id: types.customer
      }]

      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 2)

      let o = {
        icentris_client: 'bluesun',
        order_id: 456,
        tree_user_id: 1,
        status_id: 1,
        client_user_id: 'd1234',
        order_date: `${utils.formatDate(orderDate)}`,
        status: {
          id: '1',
          description: 'In Progress'
        },
        total: '70.00',
        personal_volume: '100',
        commission_volume: '60',
        autoship_template: {
          id: 1
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
      }

      o = bot.translate(bot.getClientMap(require('../../../../../bots/offload/vibe/orders/orders.json'), o.client_code), o)

      const sql = opts.mysql.squel.insert()
        .into('tree_orders')
        .setFields(o)
        .toParam()

      await opts.mysql.execute(sql.text, sql.values)

      await bot.handle(opts.event, opts.context)
      const offloadQuery = 'SELECT user_type_id FROM tree_users WHERE tree_users.client_user_id in (1234)'
      const offloadedData = await opts.mysql.execute(offloadQuery)

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.preferred_customer)
    })

    it('should not upgrade user_type_id for a customer if db.order_date not within 31 days', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        type_id: types.customer
      }]

      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 32)

      let o = {
        icentris_client: 'bluesun',
        order_id: 456,
        tree_user_id: 1,
        status_id: 1,
        client_user_id: 'd1234',
        order_date: `${utils.formatDate(orderDate)}`,
        status: {
          id: '1',
          description: 'In Progress'
        },
        total: '70.00',
        personal_volume: '100',
        commission_volume: '60',
        autoship_template: {
          id: 1
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
      }

      o = bot.translate(bot.getClientMap(require('../../../../../bots/offload/vibe/orders/orders.json'), o.client_code), o)

      const sql = opts.mysql.squel.insert()
        .into('tree_orders')
        .setFields(o)
        .toParam()

      await opts.mysql.execute(sql.text, sql.values)

      await bot.handle(opts.event, opts.context)
      const offloadQuery = 'SELECT user_type_id FROM tree_users WHERE tree_users.client_user_id in (1234)'
      const offloadedData = await opts.mysql.execute(offloadQuery)

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]
      assert.equal(out0.user_type_id, types.customer)
    })

    it('should upgrade a customer to preferred customer', async () => {
      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 2)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        autoship_template_id: 10001,
        order_date: `${utils.formatDate(orderDate)}`
      }]

      await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.customer} WHERE tree_users.id in (1)`)
      await bot.handle(opts.event, opts.context)
      const offloadedData = await opts.mysql.execute('SELECT user_type_id FROM tree_users WHERE id = 1')

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.preferred_customer)
    })

    it('should not upgrade a customer if not within the required range of 31', async () => {
      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 32)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        autoship_template_id: 10001,
        order_date: `${utils.formatDate(orderDate)}`
      }]

      await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.customer} WHERE tree_users.id in (1)`)
      await bot.handle(opts.event, opts.context)
      const offloadedData = await opts.mysql.execute('SELECT user_type_id FROM tree_users WHERE id = 1')

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.customer)
    })

    it('should not upgrade a distributor to preferred', async () => {
      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 2)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        autoship_template_id: 10001,
        order_date: `${utils.formatDate(orderDate)}`
      }]

      await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)
      await bot.handle(opts.event, opts.context)
      const offloadedData = await opts.mysql.execute('SELECT user_type_id FROM tree_users WHERE id = 1')

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.distributor)
    })

    it('should not upgrade a customer if not an autoship_template_id', async () => {
      const orderDate = new Date()
      orderDate.setDate(orderDate.getDate() - 32)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        autoship_template_id: -1,
        order_date: `${utils.formatDate(orderDate)}`
      }]

      await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.customer} WHERE tree_users.id in (1)`)
      await bot.handle(opts.event, opts.context)
      const offloadedData = await opts.mysql.execute('SELECT user_type_id FROM tree_users WHERE id = 1')

      const treeUserUplineRows = offloadedData[0]
      const out0 = treeUserUplineRows[0]

      assert.equal(out0.user_type_id, types.customer)
    })
  })
}
