'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleMappings = {
    in0: {
      dealership_id: '1234',
      dealer_id: '2345',
      earnings: '245.00',
      payable_volume: '6500',
      previous_balance: '0.00',
      balance_forward: '50.00',
      fee: '0.00',
      total: '295.00',
      bonuses: [
        {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00'
        },
        {
          bonus_type: {
            id: '2',
            description: 'For being cool'
          },
          amount: '115.00'
        }
      ],
      icentris_client: 'bluesun',
      commission_run: {
        description: 'April 2018',
        run_date: '2018-04-01 09:00:00',
        accepted_date: '2018-04-01 09:00:00',
        status: {
          id: '1',
          description: 'Started'
        },
        period: {
          period_id: '1235',
          description: 'April 2018'
        }
      }
    },
    in1: {
      dealership_id: '2344',
      dealer_id: '2345',
      earnings: '330.00',
      payable_volume: '7500',
      previous_balance: '0.00',
      balance_forward: '150.00',
      fee: '0.00',
      total: '420.00',
      bonuses: [
        {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00'
        },
        {
          bonus_type: {
            id: '2',
            description: 'For being cool'
          },
          amount: '115.00'
        }
      ],
      icentris_client: 'bluesun',
      commission_run: {
        description: 'March 2018',
        run_date: '2018-03-01 09:00:00',
        accepted_date: '2018-03-01 09:00:00',
        status: {
          id: '1',
          description: 'Started'
        },
        period: {
          period_id: '1234',
          description: 'March 2018'
        }
      }
    },
    out0: {
      icentris_client: 'bluesun',
      client_user_id: 'd1234',
      extra: {
        dealer_id: '2345',
        dealership_id: '1234'
      },
      total: '295.00',
      earnings: '245.00',
      balance_forward: '50.00',
      previous_balance: '0.00',
      payable_volume: '6500',
      fee: '0.00',
      commission_run: {
        description: 'April 2018',
        run_date: '2018-04-01 09:00:00',
        accepted_date: '2018-04-01 09:00:00',
        status: {
          id: '1',
          description: 'Started'
        },
        period: {
          client_period_id: '1235',
          period_type_id: '20',
          description: 'April 2018'
        }
      },
      commission_bonuses: [{
        bonus: {
          id: '1',
          description: 'Retail Bonus'
        },
        amount: '130.00'
      }, {
        bonus: {
          id: '2',
          description: 'For being cool'
        },
        amount: '115.00'
      }]
    },
    out1: {
      icentris_client: 'bluesun',
      client_user_id: 'd2344',
      extra: {
        dealer_id: '2345',
        dealership_id: '2344'
      },
      total: '420.00',
      earnings: '330.00',
      balance_forward: '150.00',
      previous_balance: '0.00',
      payable_volume: '7500',
      fee: '0.00',
      commission_run: {
        description: 'March 2018',
        run_date: '2018-03-01 09:00:00',
        accepted_date: '2018-03-01 09:00:00',
        status: {
          id: '1',
          description: 'Started'
        },
        period: {
          client_period_id: '1234',
          period_type_id: '20',
          description: 'March 2018'
        }
      },
      commission_bonuses: [{
        bonus: {
          id: '1',
          description: 'Retail Bonus'
        },
        amount: '130.00'
      }, {
        bonus: {
          id: '2',
          description: 'For being cool'
        },
        amount: '115.00'
      }]
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/commission')
  })

  // handle functionality was moved to the superclass TrinityLoader, but this
  // tests some actual data so it remains.
  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        sampleMappings.in0,
        sampleMappings.in1
      ]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(out0, sampleMappings.out0)
      assert.deepEqual(out1, sampleMappings.out1)
    })
  })
}
