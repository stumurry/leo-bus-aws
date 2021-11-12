'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [{
    _event: 'DEALERSHIP_DELETED',
    icentris_client: 'bluesun',
    dealership_id: '1111'
  },
  {
    _event: 'DEALERSHIP_DELETED',
    icentris_client: 'bluesun',
    dealership_id: '1112'
  }]

  const expectedOutputs = [{
    client_user_id: 'd1111',
    icentris_client: 'bluesun',
    extra: {
      // "_comment": "Client specific addon fields"
      dealership_id: '1111'
    }
  },
  {
    client_user_id: 'd1112',
    icentris_client: 'bluesun',
    extra: {
      // "_comment": "Client specific addon fields"
      dealership_id: '1112'
    }
  }
  ]

  beforeEach(() => {
    bot = opts.getBot('load/trinity/dealership_deleted')
    opts.bus.inQueueData = sampleInputs
  })

  describe('#handle', function () {
    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutput0 = opts.bus.outQueueData[0].payload
      const actualOutput1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(actualOutput0, expectedOutputs[0])
      assert.deepEqual(actualOutput1, expectedOutputs[1])
    })
  })
}
