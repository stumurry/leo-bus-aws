'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_messages'
    await opts.mysql.truncate(opts.event.table)

    const msgs = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([{
        id: 1,
        sender_id: 1,
        sender_type: 'Test::User',
        sent_date: opts.moment().utc().format('YYYY-MM-DD HH:mm:ss'),
        to: 'testy.tester@gmail.com',
        from: 'tester.testy@icentris.com',
        subject: 'Subject',
        message: 'message'
      }, {
        id: 2,
        sender_id: 2,
        sender_type: 'Test::User',
        sent_date: opts.moment().utc().format('YYYY-MM-DD HH:mm:ss'),
        to: 'testy.tester+2@gmail.com',
        from: 'tester.testy+2@icentris.com',
        subject: 'Subject2',
        message: 'message2'
      }, {
        id: 4,
        sender_id: 2,
        sender_type: 'Test::User',
        sent_date: opts.moment().utc().format('YYYY-MM-DD HH:mm:ss'),
        to: 'testy.tester+2@gmail.com',
        from: 'tester.testy+2@icentris.com',
        subject: 'Subject3',
        message: 'message3'
      }, {
        id: 5,
        sender_id: 3,
        sender_type: 'Test::User',
        sent_date: opts.moment().utc().format('YYYY-MM-DD HH:mm:ss'),
        to: 'testy.tester+2@gmail.com',
        from: 'tester.testy+2@icentris.com',
        subject: 'Subject4',
        message: 'message4'
      }])
      .toString()

    await opts.mysql.execute(msgs)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_messages: [1, 2]
        }
      },
      delete: { 'pyr-bluesun-local': { pyr_messages: [3] } }
    }, {
      update: {
        'pyr-bluesun-local': {
          pyr_messages: [4, 5]
        }
      }
    }]
  })

  describe('#handle', () => {
    it('should load the domain objects for ids 1,2,4,5', async () => {
      await bot.handle(opts.event, opts.context)

      assert(opts.bus.outQueueData.length === 4)

      const ids = opts.bus.outQueueData.map(o => {
        const p = o.payload

        assert(Object.keys(p).length > 0)
        assert.strictEqual(p.icentris_client, 'bluesun')

        return o.domain_id
      })

      assert.deepEqual([1, 2, 4, 5], ids)
    })
  })
}
