'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  const Bot = require('../../../bots/bot')
  let bot
  beforeEach(() => {
    bot = new Bot(opts.bus)
  })

  describe('#getRemoteConfig', () => {
    it('should retrieve the config from git in a decrypted format without throwing an error', async function () {
      this.timeout(50000)

      await bot.getRemoteConfig()
    })
  })

  describe('#getTenantConfigs', () => {
    it('should return an object containing all of the tenant configs', async function () {
      this.timeout(9000)

      const configs = await bot.getTenantConfigs()

      assert(Object.keys(configs).includes('bluesun'))
    })
  })

  describe('#getConfig', () => {
    it('should return an object with local params for vibe, exigo', async function () {
      this.timeout(9000)

      const config = await bot.getConfig('bluesun')
      const keys = ['exigo', 'vibe']

      keys.map(k => {
        assert(Object.keys(config).includes(k))
      })

      assert.equal(config.vibe.mysql.database, `pyr-bluesun-${process.env.NODE_ENV}`)
      assert.equal(config.exigo.user, 'sa')
    })
  })
}
