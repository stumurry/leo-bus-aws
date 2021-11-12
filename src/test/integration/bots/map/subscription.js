'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(async () => {
    await opts.bus.Promise.map(['users', 'tree_users', 'pyr_subscription_plans'], t => {
      return opts.mysql.truncate(t)
    })

    const qs = [
      opts.mysql.squel.insert()
        .into('tree_users')
        .setFieldsRows([{
          id: 1,
          client_user_id: 15
        }, {
          id: 2,
          client_user_id: 23
        }])
        .toParam(),
      opts.mysql.squel.insert()
        .into('users')
        .setFieldsRows([{
          id: 91,
          tree_user_id: 1,
          consultant_id: 15
        }, {
          id: 92,
          tree_user_id: 2,
          consultant_id: 23
        }])
        .toParam()
    ]

    await opts.bus.Promise.map(qs, q => {
      return opts.mysql.execute(q.text, q.values)
    })

    bot = opts.getBot('map/subscription')

    opts.bus.inQueueData = [{
      client_user_id: 15,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      active: true,
      subscription_plan: { id: 3, name: 'Lite' },
      icentris_client: 'bluesun'
    }, {
      client_user_id: 23,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      active: true,
      subscription_plan: { id: 5, name: 'Vibe Pro - Monthly' },
      icentris_client: 'bluesun'
    }, {
      client_user_id: 23,
      start_date: '2019-05-17T20:00:39.600Z',
      expire_date: '2019-06-17T20:00:39.600Z',
      active: true,
      subscription_plan: { id: 3, name: 'Lite' },
      icentris_client: 'bluesun'
    }]
  })

  describe('#handle', async function () {
    it('should map the user_id, tree_user_id, and subscription_plan_id', async function () {
      await bot.handle(opts.event, opts.context)

      const out = opts.bus.outQueueData
      assert.strictEqual(out.length, 3)

      const expected = [{
        tree_user_id: 1,
        user_id: 91,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-06-17T20:00:39.600Z',
        subscription_plan_id: 1,
        subscription_plan: { id: 1, name: 'Lite' },
        client_user_id: 15,
        active: true,
        icentris_client: 'bluesun'
      }, {
        tree_user_id: 2,
        user_id: 92,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-06-17T20:00:39.600Z',
        subscription_plan_id: 2,
        subscription_plan: { id: 2, name: 'Vibe Pro - Monthly' },
        client_user_id: 23,
        active: true,
        icentris_client: 'bluesun'
      }, {
        tree_user_id: 2,
        user_id: 92,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-06-17T20:00:39.600Z',
        subscription_plan_id: 1,
        subscription_plan: { id: 1, name: 'Lite' },
        client_user_id: 23,
        active: true,
        icentris_client: 'bluesun'
      }]

      expected.map((e, k) => {
        const o = out[k].payload
        assert.deepEqual(e, o)
      })
    })

    it('should throw an error if the user is not found', async function () {
      this.timeout(5000)

      await opts.mysql.truncate('users')

      try {
        await bot.handle(opts.event, opts.context)
      } catch (err) {
        return assert(true)
      }

      throw new Error('Failed to throw expected error')
    })
  })
}
