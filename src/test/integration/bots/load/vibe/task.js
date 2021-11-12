'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_user_tasks'
    await opts.mysql.truncate(opts.event.table)

    const userTasks = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([
        {
          user_id: 1,
          task_id: 1
        },
        {
          user_id: 2,
          task_id: 2
        }
      ])
      .toString()

    await opts.mysql.execute(userTasks)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_user_tasks: [1, 2]
        }
      }
    }]
  })

  describe('#handle', () => {
    it('should load the domain objects for ids 1, 2', async () => {
      await bot.handle(opts.event, opts.context)

      const ids = opts.bus.outQueueData.map(o => {
        const p = o.payload

        assert(Object.keys(p).length > 0)
        assert.strictEqual(p.icentris_client, 'bluesun')
        return o.domain_id
      })

      assert.deepEqual([1, 2], ids)
    })
  })
}
