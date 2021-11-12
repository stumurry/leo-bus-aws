'use strict'

const Bot = require('../../../bots/bot')

module.exports = (opts) => {
  const assert = opts.assert

  let bot
  beforeEach(() => {
    bot = new Bot(opts.bus)
  })

  describe('#handler', () => {
    it('should not error on a stock implementation', async () => {
      opts.bus.inQueueData = [{
        test: 'test',
        me: 'myself',
        i: null
      }]

      await bot.handle(opts.event, opts.context)

      assert(true)
    })

    it.skip('should log to the error queue when an error is encountered', async () => {
      opts.bus.inQueueData = [{
        error: true,
        name: 'Vader',
        id: 1
      }, {
        error: false,
        name: 'Luke',
        id: 2
      }, {
        error: true,
        name: 'Sidius',
        id: 3
      }, {
        error: false,
        name: 'Rey',
        id: 4
      }]

      bot.handle = async function (event, context) {
        return this.bus.offload(this.botId, event.source, (payload, meta, done) => {
          if (payload.error) {

          }
        })
      }

      await bot.handler(opts.event, opts.context, () => {
        assert.equal(opts.bus.outQueueData, 2)

        opts.bus.outQueueData.map(o => {
          console.log(o)
        })
      })
    })
  })

  describe('#getVibeDB & #closeVibeDB', () => {
    const client = process.env.TEST_TENANT || 'bluesun'
    it('should create a client db connection and then disconnecc it', () => {
      return bot.getVibeDB(client).then(conn => {
        assert.equal(conn.pool.config.connectionConfig.database, `pyr-${client}-${process.env.NODE_ENV}`)

        return bot.closeVibeDB(client)
      }).then(() => {
        assert(client in bot.clients)
        assert(!('mysql' in bot.clients[client]))
      })
    })
  })

  describe('#closeAllVibeDBs', () => {
    it('should close all database connections, delete the mysql instances from the cache and exit', () => {
      const clients = [process.env.TEST_TENANT || 'bluesun', 'galactic-empire']
      return Promise.all(clients.map(c => bot.getVibeDB(c)))
        .then(conns => {
          assert(true)
          return bot.closeAllVibeDBs()
        })
        .then(() => {
          Object.keys(bot.clients).map(c => {
            assert(!('mysql' in bot.clients[c]))
          })
        })
    })
  })

  describe('#getConfig', () => {
    it('should return an object with a maxscale field', async function () {
      this.timeout(9000)

      const config = await bot.getConfig('bluesun')
      const keys = ['maxscale']

      keys.map(k => {
        assert(Object.keys(config).includes(k))
      })

      assert.equal(config.maxscale.host, '0.0.0.0')
      assert.equal(config.maxscale.port, 4001)
      assert.equal(config.maxscale.password, 'maxpwd')
    })
  })
}
