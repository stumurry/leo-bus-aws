'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  const Bot = require('../../../../bots/passthru/commission/index')
  let bot

  beforeEach(async () => {
    bot = new Bot(opts.bus)
  })

  describe('#handle', function () {
    it('should work', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        commission_run_id: '100',
        tree_user_id: '1',
        commission_run_status_id: '2',
        period_id: '1',
        icentris_client: 'liu',
        client_user_id: '1234',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fee: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '1',
            description: 'Retail Bonus'
          },
          bonus_id: '1',
          amount: '230.00'
        }, {
          bonus: {
            id: '2',
            description: 'For being cool'
          },
          bonus_id: '2',
          amount: '35.00'
        }],
        commission_run: {
          id: '318',
          description: 'March 2018',
          run_date: '2018-03-30 09:00:00',
          accepted_date: '2018-03-31 09:00:00',
          status: {
            id: '2',
            description: 'Finished'
          },
          period: {
            client_period_id: '1234',
            period_type_id: '10',
            description: 'March 2018',
            start_date: '2018-03-01',
            end_date: '2018-03-31'
          }
        }
      }, {
        commission_run_id: '200',
        tree_user_id: '30',
        commission_run_status_id: '3',
        period_id: '2',
        icentris_client: 'liu',
        client_user_id: '3451',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fee: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '3',
            description: 'Retail Bonus'
          },
          bonus_id: '3',
          amount: '20.00'
        }, {
          bonus: {
            id: '4',
            description: 'For being cool'
          },
          bonus_id: '4',
          amount: '135.00'
        }],
        commission_run: {
          id: '418',
          description: 'April 2018',
          run_date: '2018-04-01 09:00:00',
          accepted_date: '2018-04-01 09:00:00',
          status: {
            id: '1',
            description: 'Started'
          },
          period: {
            client_period_id: '1235',
            period_type_id: '10',
            description: 'April 2018',
            start_date: '2018-04-01',
            end_date: '2018-04-30'
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const comm0 = opts.bus.outQueueData[0].payload
      const comm1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(comm0.client_user_id, '1234')
      assert.strictEqual(comm1.client_user_id, '3451')

      assert.strictEqual(comm0.tree_user_id, '1')
      assert.strictEqual(comm1.tree_user_id, '30')
    })
  })
}
