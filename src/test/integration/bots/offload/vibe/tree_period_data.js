'use strict'
module.exports = (opts) => {
  const assert = opts.assert

  describe('#handle summary data offload for tree_period_data table', () => {
    beforeEach(async () => {
      const bot = opts.getBot('offload/vibe/tree_period_data')
      await opts.mysql.execute('TRUNCATE TABLE tree_period_data')

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: 1,
        period_id: 1,
        period_type_id: 1,
        rank_id: 1,
        paid_rank_id: 2,
        client_user_id: 1,
        rank: {
          id: 1,
          client_level: 100
        },
        paid_rank: {
          id: 2,
          client_level: 200
        },
        personal_volume: 101,
        group_volume: 102,
        extreme_success_bonus: 103
      },
      {
        icentris_client: 'bluesun',
        tree_user_id: 2,
        period_id: 1,
        period_type_id: 1,
        rank_id: 2,
        paid_rank_id: 3,
        client_user_id: 2,
        rank: {
          id: 2,
          client_level: 200
        },
        paid_rank: {
          id: 3,
          client_level: 300
        },
        personal_volume: 201,
        group_volume: 202,
        extreme_success_bonus: 203
      },
      {
        icentris_client: 'idlife',
        tree_user_id: 2,
        client_user_id: 2,
        extra: {
          active: 'yes',
          autoship_pv: 1234
        }
      }
      ]

      await bot.handle(opts.event, opts.context)
    })

    it('should write two records to the tree_user_plus table without error', async () => {
      const rs = await opts.mysql.execute(
        `SELECT
          tree_user_id,
          client_user_id,
          decimal_field1,
          decimal_field2,
          decimal_field140
        FROM tree_period_data`
      ).then(rs => rs[0])

      assert.equal(rs.length, 2)
    })

    it('should map fields properly', async () => {
      const rs = await opts.mysql.execute(
        `SELECT
          tree_user_id,
          client_user_id,
          decimal_field1,
          decimal_field2,
          decimal_field140
        FROM tree_period_data`
      ).then(rs => rs[0])

      assert.equal(rs[0].decimal_field1, 101)
      assert.equal(rs[0].decimal_field2, 102)
      assert.equal(rs[0].decimal_field140, 103)
    })
  })
}
