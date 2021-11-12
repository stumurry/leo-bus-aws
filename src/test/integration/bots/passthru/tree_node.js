'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('passthru/tree_node')
  })

  describe('#handle', function () {
    beforeEach(async () => {
      opts.bus.inQueueData = [
        {
          icentris_client: 'idlife',
          type: 'placements',
          tree_user_id: 4,
          upline_id: 23456,
          client_user_id: 1,
          client_upline_id: 2345,
          level: 2,
          position: 1,
          lft: 3,
          rgt: 4
        }
      ]
    })

    it('should output a tree mapped payload ', async function () {
      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)
      const tree = opts.bus.outQueueData[0].payload

      const expectedOutput = {
        icentris_client: 'idlife',
        type: 'placements',
        tree_user_id: 4,
        upline_id: 23456,
        client_user_id: 1,
        client_upline_id: 2345,
        level: 2,
        position: 1,
        lft: 3,
        rgt: 4
      }

      assert.deepEqual(tree, expectedOutput)
    })
  })
}
