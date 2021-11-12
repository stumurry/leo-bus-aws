'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async () => {
    opts = opts.setOptsForBot('vibe/refresh_request', opts)

    await opts.setCheckpointsToCurrent(opts)

    opts.event = {
      icentris_client: 'nevetica',
      event_type: 'summary-data',
      event_payload: '{"client_user_id": "d0001"}'
    }
  })

  describe.skip('#handler', () => {
    it('should take the event payload and write to the trinity-summary-data queue', function (done) {
      opts.bot.handler(opts.event, opts.createContext(), (err, data) => {
        if (err) done(err)
        else {
          opts.checkEventsWritten(opts.event.destination, (err, _) => {
            if (err) done(err)
            else {
              const data = []
              return opts.bus.offload('test-functional-vibe-refresh-request', 'vibe-refresh-trinity-summary-data', (payload, context, cb) => {
                data.push(payload)
                cb()
              }).then(rs => {
                assert.equal(data.length, 2)

                done()
              })
            }
          })
        }
      })
    })
  })
}
