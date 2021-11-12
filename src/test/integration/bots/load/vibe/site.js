'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_sites'
    await opts.mysql.truncate(opts.event.table)

    const sites = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([
        {
          user_id: 1,
          name: 'name1',
          domain: 'domain1'
        },
        {
          user_id: 2,
          name: 'name2',
          domain: 'domain2'
        }
      ])
      .toString()

    await opts.mysql.execute(sites)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_sites: [1, 2]
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

      assert.deepEqual([1, 2], ids.sort())
    })
  })
}
