'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const testInput0 = {
    _event: 'DEALERSHIP_STATUSCHANGE',
    icentris_client: 'bluesun',
    dealership_id: '1234',
    status: {
      id: '1',
      description: 'Active'
    }
  }

  const testInput1 = {
    _event: 'DEALERSHIP_STATUSCHANGE',
    icentris_client: 'bluesun',
    dealership_id: '1235',
    status: {
      id: '7',
      description: 'Plutonium Quartz'
    }
  }

  const expectedOutput0 = {
    client_user_id: 'd1234',
    icentris_client: 'bluesun',
    status: {
      id: '1',
      description: 'Active'
    },
    extra: {
      dealership_id: '1234'
    }
  }

  const expectedOutput1 = {
    client_user_id: 'd1235',
    icentris_client: 'bluesun',
    status: {
      id: '7',
      description: 'Plutonium Quartz'
    },
    extra: {
      dealership_id: '1235'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/dealership_status_change')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        testInput0,
        testInput1
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
