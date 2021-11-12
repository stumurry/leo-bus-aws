'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  const testRecord = {
    client_user_id: '1234',
    tree_user_id: '<set in map bot>',
    period_id: '<set in map bot>',
    rank_id: '<set in map bot>',
    paid_rank_id: '<set in map bot>',
    rank: {
      id: '1',
      description: 'Regional Director'
    },
    paid_rank: {
      id: '1',
      description: 'Director'
    },
    period: {
      id: '1234',
      description: 'March 2018',
      type: {
        id: 1,
        name: 'Monthly'
      }
    },
    personal_volume: '123',
    group_volume: '123',
    extra: {
      dealer_id: '4567',
      gv_mvr: '123',
      bcq_legs: '123',
      rpc_legs: '123',
      ad_legs: '123',
      nd_legs: '123',
      vp_legs: '123',
      new_genq: '123'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('passthru/summary_data')
    // bot = new Bot(opts.bus)
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [testRecord]
    })

    it('should push a record on to outQueueData', async function () {
      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 1)
    })

    it('testRecord should be in the outQueueData', async function () {
      await bot.handle(opts.event, opts.context)
      assert.deepStrictEqual(opts.bus.outQueueData[0].payload, testRecord)
    })
  })
}
