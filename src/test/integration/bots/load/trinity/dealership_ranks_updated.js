'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/dealership_ranks_updated')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [{
        _event: 'DEALERSHIP_RANKS_UPDATED',
        icentris_client: 'bluesun',
        changes: [{
          dealership_id: '787847',
          rank: {
            id: '59',
            description: 'Nevetica Pet Consultant'
          }
        }, {
          dealership_id: '788000',
          rank: {
            id: '59',
            description: 'Nevetica Pet Consultant'
          }
        }, {
          dealership_id: '787680',
          rank: {
            id: '59',
            description: 'Nevetica Pet Consultant'
          }
        }, {
          dealership_id: '787696',
          rank: {
            id: '59',
            description: 'Nevetica Pet Consultant'
          }
        }, {
          dealership_id: '787843',
          rank: {
            id: '60',
            description: 'Senior Pet Consultant'
          }
        }, {
          dealership_id: '787469',
          rank: {
            id: '60',
            description: 'Senior Pet Consultant'
          }
        }]
      }]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      const expected = [{
        payload: {
          rank: { client_level: '59', name: 'Nevetica Pet Consultant' },
          client_user_id: 'd787847',
          extra: { dealership_id: '787847' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }, {
        payload: {
          rank: { client_level: '59', name: 'Nevetica Pet Consultant' },
          client_user_id: 'd788000',
          extra: { dealership_id: '788000' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }, {
        payload: {
          rank: { client_level: '59', name: 'Nevetica Pet Consultant' },
          client_user_id: 'd787680',
          extra: { dealership_id: '787680' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }, {
        payload: {
          rank: { client_level: '59', name: 'Nevetica Pet Consultant' },
          client_user_id: 'd787696',
          extra: { dealership_id: '787696' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }, {
        payload: {
          rank: { client_level: '60', name: 'Senior Pet Consultant' },
          client_user_id: 'd787843',
          extra: { dealership_id: '787843' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }, {
        payload: {
          rank: { client_level: '60', name: 'Senior Pet Consultant' },
          client_user_id: 'd787469',
          extra: { dealership_id: '787469' },
          _event: 'DEALERSHIP_RANKS_UPDATED',
          icentris_client: 'bluesun'
        },
        id: 'event-botId',
        event: 'test-destination'
      }]

      assert.equal(opts.bus.outQueueData.length, opts.bus.inQueueData[0].changes.length)

      opts.bus.outQueueData.map((o, i) => {
        const e = expected[i]

        assert(o.timestamp > 0)
        assert(o.event_source_timestamp > 0)

        delete o.timestamp
        delete o.event_source_timestamp

        assert.deepEqual(o, e)
      })
    })
  })
}
