'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/commission_updated')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = multiDealerships()
    })

    it('should load individual dealership payloads', async function () {
      this.timeout(3000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      opts.bus.outQueueData.map((e, k) => {
        const commissionRun = Object.assign(multiDealerships()[0].commission_run, dynamicallyGenVals()[0].commission_run)
        commissionRun.id = e.payload.commission_run.id

        assert.deepEqual(e.payload.commission_run, commissionRun)
        assert.strictEqual(e.payload.dealership_id, multiDealerships()[0].dealerships[k].dealership_id)
      })
    })
  })
}

const dynamicallyGenVals = () => ([{
  commission_run: {
    accepted_date: '1/31/2019',
    period: {
      period_id: '12019',
      description: 'January 2019',
      end_date: '1/31/2019 11:59:59 PM',
      start_date: '1/1/2019',
      type: {
        description: 'Monthly',
        id: '2'
      }
    },
    status: {
      id: '2',
      description: 'Completed'
    }
  }
}])

const multiDealerships = () => ([{
  _event: 'COMMISSION_UPDATED',
  commission_run: {
    description: 'Test Feb Comm',
    run_date: '1/31/2019',
    start_date: '1/1/2019',
    end_date: '1/31/2019 11:59:59 PM'
  },
  dealerships: [
    {
      dealership_id: '1234',
      dealer_id: '2345',
      earnings: '245.00',
      payable_volume: '6500',
      bonuses: [
        {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00'
        }, {
          bonus_type: {
            id: '2',
            description: 'For being cool'
          },
          amount: '115.00'
        }]
    },
    {
      dealership_id: '2345',
      dealer_id: '9877',
      earnings: '365.00',
      payable_volume: '10500',
      bonuses: [
        {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '230.00'
        }, {
          bonus_type: {
            id: '2',
            description: 'For being cool'
          },
          amount: '135.00'
        }]
    }]
}])
