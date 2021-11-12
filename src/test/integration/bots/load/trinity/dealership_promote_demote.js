'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const testInputs = [
    {
      _event: 'DEALERSHIP_PROMOTEDEMOTE',
      icentris_client: 'bluesun',
      dealership_id: '1234',
      rank: {
        id: '1',
        description: 'Member'
      }
    },
    {
      _event: 'DEALERSHIP_PROMOTEDEMOTE',
      icentris_client: 'bluesun',
      dealership_id: '1235',
      rank: {
        id: '2',
        description: 'Associate'
      }
    }
  ]

  const expectedOutputs = [
    {
      client_user_id: 'd1234',
      icentris_client: 'bluesun',
      rank: {
        client_level: '1',
        name: 'Member'
      },
      extra: {
        dealership_id: '1234'
      }
    },
    {
      client_user_id: 'd1235',
      icentris_client: 'bluesun',
      rank: {
        client_level: '2',
        name: 'Associate'
      },
      extra: {
        dealership_id: '1235'
      }
    }
  ]

  beforeEach(() => {
    bot = opts.getBot('load/trinity/dealership_promote_demote')
    opts.bus.inQueueData = testInputs
  })

  describe('#handle', function () {
    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutputs = [
        opts.bus.outQueueData[0].payload,
        opts.bus.outQueueData[1].payload
      ];

      [0, 1].forEach((i) => {
        assert.deepEqual(expectedOutputs[i], actualOutputs[i])
      })
    })
  })
}
