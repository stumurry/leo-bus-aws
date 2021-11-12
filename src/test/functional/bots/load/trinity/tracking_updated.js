'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async function () {
    this.timeout(21000)

    await opts.configureOpts('load/trinity/tracking_updated')

    const events = [{
      icentris_client: 'bluesun',
      order_id: 1234,
      tracking_numbers: [
        'z1234'
      ]
    }, {
      icentris_client: 'bluesun',
      order_id: 4567,
      tracking_numbers: [
        'tracking'
      ]
    }]

    return opts.bootstrapSource(events)
  })

  it.skip('should read from the new_orders queue and write to the mapped_orders queue', function (done) {
    this.timeout(5000)

    opts.bot.handler(opts.event, opts.createContext(), (err, _) => {
      if (err) done(err)
      else {
        opts.checkEventsWritten(opts.event.destination, (err, _) => {
          if (err) done(err)
          else {
            const data = []
            return opts.bus.offload(opts.event.botId, opts.event.destination, (payload, context, cb) => {
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
}
