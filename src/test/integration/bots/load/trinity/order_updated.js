'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInput0 = {
    _event: 'ORDER_UPDATED',
    icentris_client: 'bluesun',
    order_id: '1234',
    status: {
      status_id: '1',
      description: 'Accepted'
    }
  }

  const sampleInput1 = {
    _event: 'ORDER_UPDATED',
    icentris_client: 'bluesun',
    order_id: '1235',
    status: {
      status_id: '2',
      description: 'Processing'
    }
  }

  const expectedOutput0 =
  // Order: https://github.com/iCentris/leo-bus/wiki/Order
  {
    // "icentris_client": "liu",
    icentris_client: 'bluesun',
    order_id: '1234',
    // "tree_user_id": "1234",
    // "client_user_id": "1234",
    // "order_date": "2018-01-01 04:50:02",
    status: {
      id: '1',
      description: 'Accepted'
    }
    // "tracking_numbers": [
    //     "z12345",
    // "ups6700ke"
    // ],
    // "personal_volume": "100",
    // "commission_volume": "60",
    // "autoship_template": {
    //     "id": "1",
    //     "next_run_date": "2018-02-01 08:00:00",
    //     "status": {
    //         "id": "1",
    //         "description": "Active"
    //     }
    // },
    // "items": [{
    //     "sku": "sku1234",
    //     "name": "Widget 1",
    //     "description": "Does something",
    //     "quantity": "2",
    //     "unit_price": "35.00",
    //     "total_price": "70.00",
    //     "unit_volume": "10",
    //     "unit_commission_volume": "7",
    //     "total_volume": "20",
    //     "total_commission_volume": "14"
    // }],
    // "extra": {
    //     "_comment": "Takes custom properties for the specific client"
    // }
  }

  const expectedOutput1 = {
    order_id: '1235',
    icentris_client: 'bluesun',
    status: {
      id: '2',
      description: 'Processing'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/order_updated')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        sampleInput0,
        sampleInput1
      ]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(out0, expectedOutput0)
      assert.deepEqual(out1, expectedOutput1)
    })
  })
}
