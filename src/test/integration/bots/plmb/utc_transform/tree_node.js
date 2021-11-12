'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInput0 = {
    client_user_id: 1,
    type: 'sponsors',
    client_upline_id: 8,
    level: 3,
    position: 0,
    lft: 6,
    rgt: 7,
    icentris_client: 'idlife'
  }

  const expectedOutput0 = {
    client_user_id: 1,
    type: 'sponsors',
    client_upline_id: 8,
    level: 3,
    position: 0,
    lft: 6,
    rgt: 7,
    icentris_client: 'idlife'
  }

  beforeEach(async () => {
    bot = opts.getBot('plmb/utc_transform/tree_node')
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
