'use strict'

module.exports = (opts) => {
  describe('#handle', () => {
    before(async () => {
      await opts.mysql.execute('TRUNCATE TABLE event_request_refreshers')
    })
    const assert = opts.assert
    let bot
    beforeEach(async () => {
      bot = opts.getBot('vibe/refresh_request')
    })

    it('should create an event if no events in table or if interval has passed ', async () => {
      const payload = {
        icentris_client: 'bluesun',
        event_type: 'summary-data',
        event_payload: '{"client_user_id": "d00001"}'
      }
      opts.event = payload
      await bot.handle(opts.event, opts.context)

      const data = opts.bus.outQueueData
      assert.strictEqual(data[0].payload, payload)
    })
  })
}
