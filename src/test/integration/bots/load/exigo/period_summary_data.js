'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/period_summary_data')
  })

  describe('#handle', function () {
    it('should load exigo cdc changes using period summary data domainobject into queue', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            PeriodVolumes: [
              {
                CustomerID: 1
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const payload = opts.bus.outQueueData[0].payload

      assert.strictEqual(payload.rank.client_level, 1)
      assert.strictEqual(payload.rank.name, 'Member')
      assert.strictEqual(payload.paid_rank.client_level, 1)
      assert.strictEqual(payload.paid_rank.name, 'Member')
    })
  })
}
