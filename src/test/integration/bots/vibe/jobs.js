'use strict'

module.exports = (opts) => {
  let bot
  before(() => {
    bot = opts.getBot('vibe/jobs')
  })

  describe.skip('#handle', () => {
    it('should work', async () => {
      await bot.handle(opts.event, opts.context)
    })
  })
}
