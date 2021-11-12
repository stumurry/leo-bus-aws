'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const testInput0 = {
    _event: 'DEALERSHIP_SPONSORSHIPCHANGED',
    icentris_client: 'bluesun',
    dealership_id: '1234',
    sponsor: {
      dealership_id: '123',
      dealer_id: '234',
      level: 10,
      position: 0
    }
  }

  const testInput1 = {
    _event: 'DEALERSHIP_SPONSORSHIPCHANGED',
    icentris_client: 'bluesun',
    dealership_id: '1235',
    sponsor: {
      dealership_id: '124',
      dealer_id: '235',
      level: 15,
      position: 1
    }
  }

  const expectedOutput0 = {
    client_user_id: 'd1234',
    icentris_client: 'bluesun',
    upline: {
      client_sponsor_id: 'd123',
      sponsor_level: 10,
      sponsor_position: 0
    },
    extra: {
      dealership_id: '1234',
      sponsor_dealer_id: '234',
      sponsor_dealership_id: '123'
    }
  }

  const expectedOutput1 = {
    client_user_id: 'd1235',
    icentris_client: 'bluesun',
    upline: {
      client_sponsor_id: 'd124',
      sponsor_level: 15,
      sponsor_position: 1
    },
    extra: {
      dealership_id: '1235',
      sponsor_dealer_id: '235',
      sponsor_dealership_id: '124'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/dealership_sponsorship_changed')
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
