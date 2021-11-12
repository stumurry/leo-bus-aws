'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  let bot
  beforeEach(async () => {
    bot = opts.getBot('offload/vibe/tree_node')
    await opts.mysql.execute('TRUNCATE TABLE tree_placements')
    await opts.mysql.execute('TRUNCATE TABLE tree_sponsors')
  })

  describe('#handle', async function () {
    it('should offload tree_node fields to correct table', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        client_user_id: '1234',
        type: 'placements',
        client_upline_id: '10',
        tree_user_id: 1,
        upline_id: 12,
        lft: 8,
        rgt: 9,
        level: 2,
        position: 4
      }]

      const expectedOut = {
        id: 'OVERRIDE',
        tree_user_id: 1,
        upline_id: 12,
        lft: 8,
        rgt: 9,
        level: 2,
        position: 4
      }

      await bot.handle(opts.event, opts.context)
      assert(opts.bus.outQueueData.length === 0)
      return opts.mysql.execute('select * from tree_placements')
        .then(([rows, meta]) => {
          expectedOut.id = rows[0].id
          assert.deepEqual(rows[0], expectedOut)
        })
        .catch(err => {
          assert.fail(err)
        })
    })
  })
}
