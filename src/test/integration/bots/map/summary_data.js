'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await opts.mysql.execute('TRUNCATE TABLE tree_periods')
    await opts.mysql.execute('TRUNCATE TABLE  pyr_rank_definitions')

    bot = opts.getBot('map/summary_data')
  })

  describe('#handle', async function () {
    it('should pass summary data tests', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        period_type_id: null,
        period_id: null,
        client_user_id: 1,
        rank: {
          client_level: '59',
          name: 'NPC'
        },
        paid_rank: {
          client_level: '59',
          name: 'NPC'
        },
        period: {
          id: 4,
          description: 'March 2018',
          start_date: '2019-01-01',
          end_date: '2019-01-31',
          type: {
            id: 1,
            description: 'Weekly'
          }
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          dealer_id: 4567,
          new_genq: 123
        }
      }, {
        icentris_client: 'bluesun',
        client_user_id: 3,
        period_type_id: null,
        period_id: null,
        rank: {
          client_level: 8
        },
        paid_rank: {
          client_level: 4
        },
        period: {
          id: 9,
          description: 'March 2018',
          type: {
            id: 2,
            description: 'Monthly'
          }
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          dealer_id: 4567,
          new_genq: 123
        }
      },
      {
        icentris_client: 'bluesun',
        client_user_id: 4,
        period_type_id: null,
        period_id: null,
        rank: {
          client_level: 9
        },
        paid_rank: {
          client_level: 5
        },
        period: {
          id: 10,
          description: 'March 2018',
          type: {
            id: 2,
            description: 'Monthly'
          }
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          dealer_id: 4567,
          new_genq: 123
        }
      },
      {
        icentris_client: 'bluesun',
        client_user_id: 4,
        extra: {
          founding_member: '1',
          renewal_date: '0',
          eligible_for_free_idn_product: '0',
          icentris_customerid: '0',
          wellness_careington_customer_price_type: '0',
          waiting_room: '0',
          recognition_names: '1',
          ssn_ein_verified: '0',
          physician_designation: '0',
          patient_details: '0',
          referring_customer_id: '0'
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 4)

      const data1 = opts.bus.outQueueData[0].payload
      const data2 = opts.bus.outQueueData[1].payload
      const data3 = opts.bus.outQueueData[2].payload
      const data4 = opts.bus.outQueueData[3].payload

      assert.ok(data1.tree_user_id)
      assert.strictEqual(data1.period_id, 1)
      assert.strictEqual(data1.period_type_id, 1)
      assert.ok(data1.rank_id)
      assert.ok(data1.paid_rank_id)
      assert.strictEqual(data1.period.id, 4)
      assert.strictEqual(data1.period.type.id, 1)
      assert.strictEqual(data1.period.type.description, 'Weekly')

      assert.ok(data2.tree_user_id)
      assert.strictEqual(data2.period_id, 2)
      assert.strictEqual(data2.period_type_id, 2)
      assert.ok(data2.rank_id)
      assert.ok(data2.paid_rank_id)
      assert.strictEqual(data2.period.id, 9)
      assert.strictEqual(data2.period.type.id, 2)
      assert.strictEqual(data2.period.type.description, 'Monthly')

      assert.ok(data3.tree_user_id)
      assert.strictEqual(data3.period_id, 3)
      assert.strictEqual(data3.period_type_id, 2)
      assert.ok(data3.rank_id)
      assert.ok(data1.paid_rank_id)
      assert.strictEqual(data3.period.id, 10)
      assert.strictEqual(data3.period.type.id, 2)
      assert.strictEqual(data3.period.type.description, 'Monthly')

      assert.ok(data4.tree_user_id)
      assert.ok(data4.extra)
      assert.strictEqual(data4.extra.founding_member, '1')
    })
  })
}
