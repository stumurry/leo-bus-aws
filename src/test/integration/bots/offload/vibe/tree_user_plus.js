'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  describe('#handle', () => {
    beforeEach(async () => {
      const bot = opts.getBot('offload/vibe/tree_user_plus')

      await opts.mysql.truncate('tree_user_plus')

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        client_user_id: 1,
        rank_id: 1,
        paid_rank_id: 2,
        rank: {
          id: 1,
          client_level: 2
        },
        paid_rank: {
          id: 2,
          client_level: 3
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          custom: 456,
          rings_of_power: {
            elves: 3,
            dwarves: 7,
            men: 9
          }
        }
      }, {
        icentris_client: 'bluesun',
        tree_user_id: 1,
        client_user_id: 1,
        rank_id: 1,
        paid_rank_id: 2,
        rank: {
          id: 1,
          client_level: 2
        },
        paid_rank: {
          id: 2,
          client_level: 3
        },
        personal_volume: 456,
        group_volume: 456,
        extra: {
          custom: 1234,
          rings_of_power: {
            elves: 3,
            dwarves: 7,
            men: 9
          }
        }
      }, {
        icentris_client: 'bluesun',
        tree_user_id: 2,
        client_user_id: 2,
        rank_id: 1,
        paid_rank_id: 2,
        period_id: 4,
        rank: {
          id: 1,
          client_level: 2
        },
        paid_rank: {
          id: 2,
          client_level: 3
        },
        period: {
          id: 4,
          description: 'March 2018',
          type: {
            id: 1,
            description: 'Weekly'
          }
        },
        personal_volume: 456,
        group_volume: 456,
        extra: {
          custom: 1234,
          rings_of_power: {
            elves: 3,
            dwarves: 7,
            men: 9
          }
        }
      }, {
        icentris_client: 'bluesun',
        tree_user_id: 2,
        client_user_id: 3,
        rank_id: 8,
        paid_rank_id: 4,
        rank: {
          id: 8,
          client_level: 10
        },
        paid_rank: {
          id: 4,
          client_level: 5
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          custom: 9875,
          rings_of_power: {
            elves: 3,
            dwarves: 7,
            men: 9
          }
        }
      }, {
        icentris_client: 'galactic_empire',
        tree_user_id: 100,
        client_user_id: 300,
        rank_id: 8,
        paid_rank_id: 4,
        rank: {
          id: 8,
          client_level: 10
        },
        paid_rank: {
          id: 4,
          client_level: 5
        },
        personal_volume: 123,
        group_volume: 123,
        extra: {
          custom: 9875,
          rings_of_power: {
            elves: 3,
            dwarves: 7,
            men: 9
          }
        }
      }]

      await bot.handle(opts.event, opts.context)
    })

    it('should write two records to the tree_user_plus table without error', async () => {
      assert(opts.bus.outQueueData.length === 0)

      const rs = await opts.mysql.execute(
        `SELECT
          tree_user_id,
          client_user_id,
          int_field1,
          int_field2,
          int_field3
        FROM tree_user_plus`
      ).then(rs => rs[0])

      assert.equal(rs.length, 2)
    })

    it('should skip records with an icentris_client value that does not have a corresponding map', async () => {
      const rs = await opts.mysql.execute('SELECT tree_user_id FROM tree_user_plus WHERE tree_user_id = 100').then(rs => rs[0])
      assert.equal(rs.length, 0)
    })

    it('should skip records with a valid period_id or period payload', async () => {
      const rs = await opts.mysql.execute('SELECT tree_user_id FROM tree_user_plus WHERE client_user_id = 2').then(rs => rs[0])
      assert.equal(rs.length, 0)
    })

    it('should replace earlier inserts with later ones so for tree_user_id = 1, int_field3 = 1234', async () => {
      const rs = await opts.mysql.execute('SELECT int_field3 FROM tree_user_plus WHERE tree_user_id = 1').then(rs => rs[0])
      assert.equal(rs[0].int_field3, 1234)
    })

    it('should write nested extra values to the tree_user_plus table according to the mapping', async () => {
      assert(opts.bus.outQueueData.length === 0)

      const rs = await opts.mysql.execute(
        `SELECT
          int_field4,
          int_field5,
          int_field6,
          int_field7
        FROM tree_user_plus`
      ).then(rs => rs[0])
      assert.equal(rs[0].int_field5, 7)
      assert.equal(rs[0].int_field6, 9)
    })
  })
}
