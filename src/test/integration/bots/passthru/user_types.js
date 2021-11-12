'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('passthru/user_types')
  })

  describe('#handle', function () {
    beforeEach(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_users')

      opts.bus.inQueueData = [
        {
          icentris_client: 'bluesun',
          tree_user_id: 1,
          rank_id: 1,
          type_id: 1,
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
        }]
    })

    it('should output a payload with type_id', async function () {
      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)
      const user0 = opts.bus.outQueueData[0].payload
      const expectedOutput = {
        icentris_client: 'bluesun',
        tree_user_id: 1,
        type_id: 1
      }
      assert.deepEqual(user0, expectedOutput)
    })
  })
}
