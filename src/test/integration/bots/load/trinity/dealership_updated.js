'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const testInput0 = {
    _event: 'DEALERSHIP_UPDATED',
    icentris_client: 'bluesun',
    dealership_id: '1234',
    position: '1'
  }

  const testInput1 = {
    _event: 'DEALERSHIP_UPDATED',
    icentris_client: 'bluesun',
    dealership_id: '2345',
    position: '2'
  }

  const expectedOutput0 = {
    client_user_id: 'd1234',
    icentris_client: 'bluesun',
    upline: {
      position: '1'
    },
    extra: {
      dealership_id: '1234'
    },
    is_downline_contact: true
  }

  const expectedOutput1 = {
    icentris_client: 'bluesun',
    client_user_id: 'd2345',
    upline: {
      position: '2'
    },
    extra: {
      dealership_id: '2345'
    },
    is_downline_contact: true
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/dealership_updated')
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
