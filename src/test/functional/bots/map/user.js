'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async function () {
    this.timeout(21000)

    opts = opts.setOptsForBot('map/user', opts)

    await Promise.all([
      opts.mysql.execute('TRUNCATE TABLE tree_users'),
      opts.mysql.execute('TRUNCATE TABLE tree_user_types'),
      opts.mysql.execute('TRUNCATE TABLE pyr_rank_definitions'),
      opts.mysql.execute('TRUNCATE TABLE tree_user_statuses')
    ])

    const events = [{
      icentris_client: 'bluesun',
      client_user_id: 1234,
      first_name: 'Darth',
      last_name: 'Vader',
      rank: {
        id: 2,
        name: 'Lord'
      },
      type: {
        id: 2,
        description: 'Sith'
      },
      status: {
        id: 4,
        description: 'Deceased'
      },
      upline: {
        client_sponsor_id: 1432
      }
    }, {
      icentris_client: 'bluesun',
      client_user_id: 1432,
      first_name: 'Darth',
      last_name: 'Sidius',
      rank: {
        id: 1,
        name: 'Emperor'
      },
      type: {
        id: 2,
        description: 'Sith'
      },
      status: {
        id: 4,
        description: 'Deceased'
      }
    }]

    opts.setCheckpointsToCurrent(opts)

    return opts.bootstrapSource(opts, events)
  })

  it.skip('should read from the new_users queue and write to the mapped_users queue', function (done) {
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
              assert.equal(data.length, 2)

              assert.equal(data[0].last_name, 'Vader')
              assert.equal(data[1].last_name, 'Sidius')

              done()
            })
          }
        })
      }
    })
  })
}
