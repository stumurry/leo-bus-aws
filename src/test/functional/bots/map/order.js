'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async function () {
    this.timeout(21001)

    await opts.configureOpts('map/order')

    await Promise.all([
      opts.mysql.execute('TRUNCATE TABLE tree_users'),
      opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')
    ])

    const events = [{
      icentris_client: 'bluesun',
      order_id: 1234,
      tracking_numbers: [
        'z1234'
      ]
    }, {
      icentris_client: 'bluesun',
      order_id: 5678,
      status: {
        id: 6,
        description: 'Dead'
      }
    }, {
      icentris_client: 'bluesun',
      client_user_id: 1432,
      order_id: 4321,
      status: {
        id: 2,
        description: 'Shipped'
      }
    }]

    return opts.bootstrapSource(events)
  })

  it.skip('should read from the new-orders queue and write to the mapped-orders queue', function (done) {
    this.timeout(21000)

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
              assert.equal(data.length, 3)
              assert.equal(data[0].order_id, 1234)
              assert.equal(data[1].status_id, 6)
              assert('tree_user_id' in data[2] && data[2].tree_user_id > 0)

              done()
            })
          }
        })
      }
    })
  })
}
