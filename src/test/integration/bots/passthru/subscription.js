'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('passthru/user')

    opts.bus.inQueueData = [{
      tree_user_id: 1,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      subscription_plan_id: 1,
      subscription_plan: { id: 1, name: 'Lite' },
      client_user_id: 1,
      active: true,
      icentris_client: 'bluesun'
    }, {
      tree_user_id: 2,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      subscription_plan_id: 2,
      subscription_plan: { id: 2, name: 'Vibe Pro - Monthly' },
      client_user_id: 2,
      active: true,
      icentris_client: 'bluesun'
    }, {
      tree_user_id: 2,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      subscription_plan_id: 1,
      subscription_plan: { id: 1, name: 'Lite' },
      client_user_id: 2,
      active: true,
      icentris_client: 'bluesun'
    }]
  })

  describe('#handle', async function () {
    it('should move the payload from source to destination with no changes', async function () {
      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 3)

      opts.bus.outQueueData.map((o, k) => {
        const i = opts.bus.inQueueData[k]
        assert.deepEqual(o.payload, i)
      })
    })
  })
}
