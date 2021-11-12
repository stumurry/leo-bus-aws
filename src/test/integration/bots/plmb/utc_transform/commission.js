'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('plmb/utc_transform/commission')
  })

  describe('#handle', function () {
    it('should work', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        commission_run_id: '100',
        tree_user_id: '1',
        commission_run_status_id: '2',
        period_id: '1',
        icentris_client: 'nevetica',
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
        icentris_client: 'idlife',
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
            start_date: '1/04/2018',
            end_date: '2018-04-30'
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const comm0 = opts.bus.outQueueData[0].payload
      const comm1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(comm0.commission_run.run_date, '2018-03-30 15:00:00')
      assert.strictEqual(comm1.commission_run.accepted_date, '2018-04-01 14:00:00')
      assert.strictEqual(comm0.commission_run.period.start_date, '2018-03-01 06:00:00')
      assert.strictEqual(comm1.commission_run.period.end_date, '2018-04-30 05:00:00')
    })
  })
}
