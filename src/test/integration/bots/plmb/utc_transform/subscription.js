'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInput0 = {
    client_user_id: 1,
    start_date: '2019-07-15T15:08:49.247Z',
    expire_date: '2019-08-15T15:08:49.247Z',
    active: true,
    subscription_plan: {
      id: 1,
      name: 'Lite'
    },
    icentris_client: 'idlife'
  }

  const expectedOutput0 = {
    client_user_id: 1,
    start_date: '2019-07-15 15:08:49',
    expire_date: '2019-08-15 15:08:49',
    active: true,
    subscription_plan: {
      id: 1,
      name: 'Lite'
    },
    icentris_client: 'idlife'
  }

  beforeEach(async () => {
    bot = opts.getBot('plmb/utc_transform/subscription')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        sampleInput0
      ]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const out0 = opts.bus.outQueueData[0].payload
      assert.deepEqual(out0, expectedOutput0)
    })
  })
}
