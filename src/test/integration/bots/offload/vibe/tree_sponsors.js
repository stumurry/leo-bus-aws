'use strict'

const fs = require('fs')

module.exports = (opts) => {
  const assert = opts.assert
  const data = `{"id": "1", "parentId": null, "lft": "0", "rgt": "5", "position": "0", "level": "0"}
{"id": "2", "parentId": "1", "lft": "1", "rgt": "4", "position": "1", "level": "1"}
{"id": "3", "parentId": "1", "lft": "2", "rgt": "3", "position": "0", "level": "2"}`

  let bot
  beforeEach(async () => {
    bot = opts.getBot('offload/vibe/tree/sponsors')

    const path = `${process.cwd()}/test/mocks/icentris-bus-${process.env.NODE_ENV}/tree/sponsor`
    fs.writeFileSync(`${path}/bluesun.ndjson`, data)

    opts.mysql.truncate('tree_sponsors')

    opts.bus.inQueueData = [{
      icentris_client: 'bluesun',
      type: 'sponsor'
    }]
  })

  describe('#handle', () => {
    it('creates the tmp sponsors tbl, reads the s3 file contents and writes them to the tmp tbl in vibe', async () => {
      try {
        await bot.handle(opts.event, opts.context)

        assert(opts.bus.outQueueData.length === 0)

        return opts.mysql.execute('select * from tree_sponsors')
          .then(([rows, meta]) => {
            assert.strictEqual(rows[0].tree_user_id, 1)
            assert.strictEqual(rows[1].upline_id, 1)
            assert.strictEqual(rows[2].lft, 2)
          })
      } catch (err) {
        assert.fail(err)
      }
    })
  })
}
