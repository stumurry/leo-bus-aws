'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_site_visitors'
    await opts.mysql.truncate(opts.event.table)

    const siteVisitors = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([
        {
          site_id: 1,
          visitor_id: 1,
          last_visit_date: '2018-12-25 23:58:00',
          visit_count: 2,
          ipaddress: `196.28.193.1`,
          browser_agent: 'Chrome',
          created_at: '2018-12-25 23:58:00'
        },
        {
          site_id: 2,
          visitor_id: 2,
          last_visit_date: '2018-12-25 23:58:00',
          visit_count: 4,
          ipaddress: `196.28.193.2`,
          browser_agent: 'Chrome',
          created_at: '2018-12-25 23:58:00'
        }
      ])
      .toString()

    await opts.mysql.execute(siteVisitors)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_site_visitors: [1, 2]
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
