'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  describe.skip('#handle', function () {
    beforeEach(async function () {
      this.timeout(64000)

      opts = opts.setOptsForBot('offload/splunk/errors', opts)

      const events = []
      for (let i = 0; i < 22; i++) {
        events.push({
          client: 'bluesun',
          type: 'error',
          message: `test-error-${i}`,
          eventId: 'eventId-1',
          event: {
            botId: 'OffloadSplunkErrors',
            source: opts.event.source
          },
          error: {
            name: 'Error',
            message: `test-error-${i}`
          },
          data: {
            id: 1,
            sensitive_field1: 'a secret',
            sensitive_field2: 'another secret'
          }
        })
      }

      opts.setCheckpointsToCurrent(opts)

      await opts.bootstrapSource(opts, events)
    })

    it('should post the errors to splunk', function (done) {
      this.timeout(64000)

      opts.bot.handler(opts.event, opts.createContext(), (err, _) => {
        if (err) done(err)
        else {
          assert(true)
          done()
        }
      })
    })
  })
}
