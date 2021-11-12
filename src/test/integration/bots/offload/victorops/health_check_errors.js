'use strict'

module.exports = (opts) => {
  // const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = opts.getBot('offload/victorops/health_check_errors')

    opts.bus.inQueueData = [
      {
        payload: {
          message: 'foo',
          entity_id: 'leo-bus-foo'
        }
      }
    ]
  })

  describe('#handle', function () {
    it('successfully POSTs data to VictorOps', async function () {
      opts.nock('http://victorops-test')
        .post('/integrations/generic/20131114/alert/939547f2-ae94-4453-9179-c9b3ee91c749/dtm', JSON.stringify({ message_type: 'CRITICAL', entity_id: opts.bus.inQueueData[0].payload.entity_id, entity_display_name: `Health Check Error - leo-bus-${process.env.NODE_ENV}`, state_message: opts.bus.inQueueData[0].payload.message }))
        .reply(200, JSON.stringify({ result: 'success', entity_id: opts.bus.inQueueData[0].payload.entity_id }))
        // .log(console.log)

      await bot.handle(opts.event, opts.context)
    })
  })
}
