'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  const Bot = require('../../../../bots/passthru/bot')
  let bot
  beforeEach(() => {
    bot = new Bot(opts.bus)
  })

  describe('#handle', () => {
    it('should run the provided each statement on the inqueue and output the same to the outqueue and then exit', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'test',
        test: true
      }]

      bot.each = (payload) => {
        return Promise.resolve(payload)
      }

      await bot.handle(opts.event, opts.context)

      assert.equal(opts.bus.outQueueData.length, 1)

      assert.deepEqual(opts.bus.outQueueData[0].payload, opts.bus.inQueueData[0])
    })

    it('should run the Promise.all each statement on an inqueue of multiple items and exit successfully', () => {
      opts.bus.inQueueData = [{
        icentris_client: 'test',
        test: true
      }, {
        icentris_client: 'test2',
        test: false
      }]

      bot.each = (payload) => {
        return Promise.all([Promise.resolve(1), Promise.resolve(2)])
      }

      return bot.handle(opts.event, opts.context).then(() => {
        assert(true)
      })
    })
  })
}
