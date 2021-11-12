'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/subscription')
  })

  describe('#handle', function () {
    it('should load exigo cdc changes using domainobject into queue', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            CustomerSubscriptions: [
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

      assert.strictEqual(payload.client_user_id, 1)
      assert.strictEqual(payload.active, true)
      assert.deepEqual(payload.subscription_plan, { id: 1, name: 'Lite' })
    })
  })
}
