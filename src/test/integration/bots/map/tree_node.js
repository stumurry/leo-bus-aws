'use strict'
const Mapper = require('../../../../bots/map/mapper')

module.exports = (opts) => {
  const assert = opts.assert
  let mapper

  before(() => {
    mapper = new Mapper(opts.mysql)
  })

  let bot
  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await mapper.treeUserId('1234')
    bot = opts.getBot('map/tree_node')
  })

  describe('#handle', async function () {
    it('should map required field and pass payload for placements', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        client_user_id: '12',
        type: 'placements',
        client_upline_id: '10',
        level: 2,
        position: 4,
        lft: 8,
        rgt: 9
      }]
      const query = `
        UPDATE tree_users 
        SET client_parent_id = ${opts.bus.inQueueData[0].client_upline_id}
        WHERE tree_users.client_user_id = '1234'
      `
      await opts.mysql.execute(query)
      await bot.handle(opts.event, opts.context)
      assert.equal(opts.bus.outQueueData.length, 1)

      const out = opts.bus.outQueueData[0].payload
      assert.equal(out.upline_id, 1)
    })
  })
}
