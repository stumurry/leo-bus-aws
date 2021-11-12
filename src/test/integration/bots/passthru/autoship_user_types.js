'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('passthru/autoship_user_types')
  })

  describe('#handle', function () {
    beforeEach(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')
      await opts.mysql.execute('TRUNCATE TABLE tree_users')

      opts.bus.inQueueData = [
        {
          icentris_client: 'bluesun',
          tree_user_id: 1,
          status_id: 5,
          client_user_id: 1,
          order_date: '2018-01-01 10:04:30',
          autoship_template: {
            id: '10001'
          },
          status: {
            id: 5,
            description: 'Ready'
          },
          total: 450
        }
      ]
    })

    it('should output a payload with type_id', async function () {
      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)
      const user0 = opts.bus.outQueueData[0].payload

      const expectedOutput = {
        icentris_client: 'bluesun',
        tree_user_id: 1,
        autoship_template_id: 10001,
        order_date: '2018-01-01 10:04:30'
      }

      assert.deepEqual(user0, expectedOutput)
    })
  })
}
