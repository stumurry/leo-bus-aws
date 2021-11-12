'use strict'

const moment = require('moment')

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(() => {
    bot = opts.getBot('offload/vibe/subscriptions')
  })

  describe('#handle', async function () {
    before(async () => {
      await opts.mysql.truncate('pyr_subscriptions')
    })

    it('should write the pyr_subscriptions record when none exists', async function () {
      opts.bus.inQueueData = [{
        tree_user_id: 1,
        user_id: 2,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-06-17T20:00:39.600Z',
        subscription_plan_id: 1,
        subscription_plan: { id: 1, name: 'Lite' },
        client_user_id: 1,
        active: true,
        icentris_client: 'bluesun'
      }, {
        tree_user_id: 2,
        user_id: 5,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-06-17T20:00:39.600Z',
        subscription_plan_id: 2,
        subscription_plan: { id: 2, name: 'Vibe Pro - Monthly' },
        client_user_id: 2,
        active: true,
        icentris_client: 'bluesun'
      }]

      await bot.handle(opts.event, opts.context)

      assert.deepEqual(opts.bus.outQueueData, [])

      return opts.mysql.execute('SELECT * FROM pyr_subscriptions')
        .then(([rs, _]) => {
          assert.strictEqual(rs.length, 2)

          rs.map((o, k) => {
            const i = opts.bus.inQueueData[k]

            assert.strictEqual(o.user_id, i.user_id)

            assert.strictEqual(o.subscription_plan_id, i.subscription_plan_id)
            assert.strictEqual(o.active, 1)
            assert.strictEqual(moment(o.next_billing_date).format('Y-M-D'), moment(i.expire_date).format('Y-M-D'))
          })
        })
    })

    it('should update an existing subscription if the subscription_plan_id is greater than the current value', async function () {
      opts.bus.inQueueData = [{
        tree_user_id: 1,
        user_id: 2,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-07-17T20:00:39.600Z',
        subscription_plan_id: 2,
        subscription_plan: { id: 2, name: 'Vibe Pro - Monthly' },
        client_user_id: 1,
        active: true,
        icentris_client: 'bluesun'
      }]

      await bot.handle(opts.event, opts.context)

      assert.deepEqual(opts.bus.outQueueData, [])

      return opts.mysql.execute('SELECT * FROM pyr_subscriptions WHERE user_id = 2')
        .then(([rs, _]) => {
          assert.strictEqual(rs.length, 1)

          assert.strictEqual(rs[0].subscription_plan_id, 2)
          assert.strictEqual(moment(rs[0].next_billing_date).format('Y-M-D'), moment(opts.bus.inQueueData[0].expire_date).format('Y-M-D'))
        })
    })

    it('should NOT update an existing subscription if the subscription_plan_id is lower than the current value', async function () {
      opts.bus.inQueueData = [{
        tree_user_id: 2,
        user_id: 5,
        start_date: '2019-05-17T20:00:39.600Z',
        expire_date: '2019-07-17T20:00:39.600Z',
        subscription_plan_id: 1,
        subscription_plan: { id: 1, name: 'Lite' },
        client_user_id: 2,
        active: true,
        icentris_client: 'bluesun'
      }]

      await bot.handle(opts.event, opts.context)

      assert.deepEqual(opts.bus.outQueueData, [])

      return opts.mysql.execute('SELECT * FROM pyr_subscriptions WHERE user_id = 5')
        .then(([rs, _]) => {
          assert.strictEqual(rs.length, 1)

          assert.strictEqual(rs[0].subscription_plan_id, 2)
          assert.strictEqual(Math.round(moment.duration(moment(rs[0].next_billing_date).diff(opts.bus.inQueueData[0].expire_date)).asMonths(), 0), -1)
        })
    })
  })
}
