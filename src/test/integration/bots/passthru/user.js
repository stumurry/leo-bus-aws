'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  const Bot = require('../../../../bots/passthru/user/index')
  let bot

  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await opts.mysql.execute('TRUNCATE TABLE tree_user_types')
    await opts.mysql.execute('TRUNCATE TABLE tree_user_statuses')
    await opts.mysql.execute('TRUNCATE TABLE  pyr_rank_definitions')

    bot = new Bot(opts.bus)
  })

  describe('#handle', async function () {
    it('should work', async function () {
      this.timeout(5000)
      opts.bus.inQueueData = [
        {
          tree_user_id: 1,
          rank_id: 1,
          user_type_id: 1,
          user_status_id: 3,
          parent_id: 3,
          sponsor_id: 2,
          client_user_id: 1,
          first_name: 'Garven',
          last_name: 'Dreis',
          email: 'garven.dreis@rebelalliance.org',
          rank: {
            client_level: 2,
            name: 'Squad Leader'
          },
          type: {
            id: 1,
            description: 'Rebel'
          },
          status: {
            id: 3,
            description: 'kia'
          },
          upline: {
            client_parent_id: 1234,
            client_sponsor_id: 12
          }
        }, {
          tree_user_id: 4,
          rank_id: 2,
          user_type_id: 2,
          user_status_id: 4,
          parent_id: 5,
          sponsor_id: 6,
          client_user_id: 5,
          first_name: 'Darth',
          last_name: 'Vader',
          email: 'vader@evilempire.biz',
          rank: {
            client_level: 5,
            name: 'Lord'
          },
          type: {
            id: 2,
            description: 'Sith'
          },
          status: {
            id: 4,
            description: 'deceased'
          },
          upline: {
            client_parent_id: '1235',
            client_sponsor_id: '2468'
          }
        }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const user0 = opts.bus.outQueueData[0].payload
      const user1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(user1.first_name, 'Darth')
      assert.strictEqual(user1.last_name, 'Vader')

      assert.strictEqual(user0.rank_id, 1)
      assert.strictEqual(user1.rank_id, 2)

      assert.strictEqual(user0.user_type_id, 1)
      assert.strictEqual(user1.user_type_id, 2)

      assert.strictEqual(user0.user_status_id, 3)
      assert.strictEqual(user1.user_status_id, 4)
    })
  })
}
