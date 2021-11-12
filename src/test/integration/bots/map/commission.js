'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await opts.mysql.execute('TRUNCATE TABLE tree_commissions')
    await opts.mysql.execute('TRUNCATE TABLE tree_commission_runs')
    await opts.mysql.execute('TRUNCATE TABLE tree_commission_run_statuses')
    await opts.mysql.execute('TRUNCATE TABLE tree_periods')
    await opts.mysql.execute('TRUNCATE TABLE tree_bonuses')
    await opts.mysql.execute('TRUNCATE TABLE tree_commission_bonuses')
    bot = opts.getBot('map/commission')
  })

  describe('#handle', function () {
    it('should work', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        client_user_id: '1234',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fees: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '230.00'
        }, {
          bonus: {
            id: '2',
            description: 'For being cool'
          },
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
            client_period_id: 1234,
            description: 'March 2018',
            start_date: '2018-03-01',
            end_date: '2018-03-31',
            type: {
              id: '1',
              description: 'Weekly'
            }
          }
        }
      }, {
        icentris_client: 'bluesun',
        client_user_id: '3451',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fees: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '20.00'
        }, {
          bonus: {
            id: '2',
            description: 'For being cool'
          },
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
            client_period_id: 1235,
            description: 'April 2018',
            start_date: '2018-04-01',
            end_date: '2018-04-30',
            type: {
              id: '2',
              description: 'Monthly'
            }
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const comm0 = opts.bus.outQueueData[0].payload
      const comm1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(comm0.client_user_id, '1234')
      assert.strictEqual(comm1.client_user_id, '3451')

      assert.strictEqual(comm0.tree_user_id, 1)
      assert.strictEqual(comm1.tree_user_id, 2)

      assert.ok(comm0.commission_run_id)
      assert.ok(comm0.commission_run_status_id)

      assert.strictEqual(comm0.period_id, 1)
      assert.strictEqual(comm0.period_type_id, 1)

      assert.ok(comm1.commission_run_id)
      assert.ok(comm1.commission_run_status_id)
      assert.strictEqual(comm1.period_id, 2)
      assert.strictEqual(comm1.period_type_id, 2)

      assert.ok(comm0.commission_bonuses[0].bonus_id)
      assert.ok(comm0.commission_bonuses[1].bonus_id)
      assert.ok(comm1.commission_bonuses[0].bonus_id)
      assert.ok(comm1.commission_bonuses[1].bonus_id)
    })
  })
}
