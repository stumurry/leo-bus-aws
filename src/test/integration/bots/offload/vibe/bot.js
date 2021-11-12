'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  let bot
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/bot')
  })

  describe('#getClientMap', () => {
    it('should return the default map for a client with no overriding map', () => {
      const map = {
        default: {
          id: 'id',
          string: 'string'
        }
      }

      const clientMap = bot.getClientMap(map, 'bluesun')
      assert.deepEqual(clientMap, {
        id: 'id',
        string: 'string'
      })
    })

    it('should return the default map + custom attribute for a client with an overriding map', () => {
      const map = {
        default: {
          id: 'id',
          lft: 'left',
          rgt: 'rght',
          pos: 'position'
        },
        bluesun: {
          pos: 'position2',
          new: 'new'
        }
      }

      const clientMap = bot.getClientMap(map, 'bluesun')
      assert.deepEqual(clientMap, {
        id: 'id',
        lft: 'left',
        rgt: 'rght',
        pos: 'position2',
        new: 'new'
      })
    })
  })

  describe('#applyTransforms', () => {
    it('returns an empty object if no transforms are available', () => {
      const table = 'a_table_for_which_there_is_no_transform'
      const payload = {
        username: 'margaret111',
        assets: {
          resources: ['document a', 'document b'],
          images: ['pic 1', 'pic 2']
        }
      }
      assert.deepEqual({}, bot.applyTransforms(payload, table))
    })

    it('uses a transform if one is appropriately named', () => {
      const table = 'blue_sun_super_users'
      const payload = {
        username: 'margaret111',
        assets: {
          resources: ['document a', 'document b'],
          images: ['pic 1', 'pic 2']
        }
      }

      bot.blueSunSuperUsersOffloadTransforms = (payload, table) => {
        return {
          image_titles: payload.assets.images
        }
      }

      const expected = {
        image_titles: ['pic 1', 'pic 2']
      }

      assert.deepEqual(expected, bot.applyTransforms(payload, table))

      bot.blueSunSuperUsersOffloadTransforms = undefined
    })
  })

  describe('#translate', () => {
    it('should map key values from the source object to the key values for the destination', () => {
      const map = {
        generic: 'specific',
        me: 'myself',
        field: 'field_1'
      }

      const obj = bot.translate(map, {
        generic: 'string',
        me: 42,
        field: 'letmein'
      })

      assert.deepEqual(obj, {
        specific: 'string',
        myself: 42,
        field_1: 'letmein'
      })
    })

    it('should preserve keys that are not mapped', () => {
      const map = {}

      const obj = bot.translate(map, {
        field: 1,
        field2: 'two'
      })

      assert.deepEqual(obj, obj)
    })
  })

  describe('#handle', () => {
    beforeEach(async () => {
      opts.bus.inQueueData = [{
        client: 'bluesun',
        error: true,
        name: 'Vader',
        id: 1
      }, {
        client: 'bluesun',
        error: false,
        name: 'Luke',
        id: 2
      }, {
        client: 'bluesun',
        error: true,
        name: 'Sidius',
        id: 3
      }, {
        client: 'bluesun',
        error: false,
        name: 'Rey',
        id: 4
      }]

      const Bot = require('../../../../../bots/offload/vibe/bot')

      class TestBot extends Bot {
        async each (payload) {
          if (payload.error) {
            throw new Error(`failure on payload id ${payload.id}`)
          }

          return Promise.resolve()
        }
      }

      bot = new TestBot(opts.bus)
    })

    it('should route errors to the error queue and continue processing the data', async () => {
      await bot.handle(opts.event, opts.context)

      assert.equal(opts.bus.outQueueData.length, 2)

      const outQueueData = opts.bus.outQueueData

      assert.equal(outQueueData[0].payload.event.botId, 'event-botId')
      assert(outQueueData[0].payload.eventId)
      assert.equal(outQueueData[0].payload.error.message, 'failure on payload id 1')
      assert.equal(outQueueData[1].payload.error.message, 'failure on payload id 3')
    })

    it('should write ETL status record for each event', async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_etl_statuses')

      // We need bot.clients to get populated to trigger the status insert
      const client = process.env.TEST_TENANT || 'bluesun'
      await bot.getVibeDB(client)

      await bot.handle(opts.event, opts.context)

      const rs = await opts.mysql.execute('SELECT * FROM tree_etl_statuses').then(rs => rs[0])

      assert.equal(rs.length, 1)
    })
  })
}
