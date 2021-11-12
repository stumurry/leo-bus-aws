'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_message_recipients'
    await opts.mysql.truncate(opts.event.table)

    const rcpts = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([
        {
          id: 1,
          message_id: 1,
          recipient_id: 1,
          recipient_type: 'Test::User',
          delivery_type: 'email',
          to: 'test.1@gmail.com'
        },
        {
          id: 2,
          message_id: 2,
          recipient_id: 2,
          recipient_type: 'Test::User',
          delivery_type: 'email',
          to: 'test.2@gmail.com'
        }
      ])
      .toString()

    await opts.mysql.execute(rcpts)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_message_recipients: [1, 2]
        }
      },
      delete: { 'pyr-bluesun-local': { pyr_message_recipients: [3] } }
    }]
  })

  describe('#handle', () => {
    it('should load the domain objects for ids 1, 2', async () => {
      await bot.handle(opts.event, opts.context)

      assert(opts.bus.outQueueData.length === 2)

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
