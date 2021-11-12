'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async function () {
    this.timeout(64000)

    /* truncate table tree_placements; */
    opts = opts.setOptsForBot('offload/vibe/tree/placements', opts)

    await opts.setCheckpointsToCurrent(opts)

    const events = [
      { icentris_client: 'listenuniversity', tree_user_id: 10, parent_id: 100, level: 10, position: 1 },
      { icentris_client: 'listenuniversity', tree_user_id: 1, parent_id: null, level: 0, position: 0 },
      { icentris_client: 'listenuniversity', tree_user_id: 2, parent_id: 1, level: 1, position: 0 },
      { icentris_client: 'listenuniversity', tree_user_id: 3, parent_id: 1, level: 1, position: 1 },
      { icentris_client: 'listenuniversity', tree_user_id: 4, parent_id: 2, level: 2, position: 1 },
      { icentris_client: 'listenuniversity', tree_user_id: 5, parent_id: 4, level: 2, position: 0 },
      { icentris_client: 'listenuniversity', tree_user_id: 6, parent_id: 4, level: 1, position: 1 },
      { icentris_client: 'listenuniversity', tree_user_id: 7, parent_id: 3, level: 2, position: 0 }
      /*
      {icentris_client: 'listenuniversity', tree_user_id: 8, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 9, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 10, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 11, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 12, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 13, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 14, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 15, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 16, parent_id: 12, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 17, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 18, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 19, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 20, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 21, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 22, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 23, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 24, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 25, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 26, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 27, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 28, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 29, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 30, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 31, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 32, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 33, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 34, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 35, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 36, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 37, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 38, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 39, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 40, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 41, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 42, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 43, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 44, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 45, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 46, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 47, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 48, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 49, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 50, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 51, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 52, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 53, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 54, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 55, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 56, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 57, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 58, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 59, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 60, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 61, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 62, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 63, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 64, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 65, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 66, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 67, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 68, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 69, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 70, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 71, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 72, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 73, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 74, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 75, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 76, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 77, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 78, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 79, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 80, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 81, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 82, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 83, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 84, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 85, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 86, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 87, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 88, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 89, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 90, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 91, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 92, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 93, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 94, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 95, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 96, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 97, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 98, parent_id: 3, level: 2, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 100, parent_id: 0, level: 3, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 101, parent_id: 1, level: 4, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 102, parent_id: 1, level: 4, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 103, parent_id: 3, level: 5, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 104, parent_id: 4, level: 6, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 105, parent_id: 3, level: 5, position: null},
      {icentris_client: 'listenuniversity', tree_user_id: 106, parent_id: 6, level: 6, position: null}
      */
    ]

    return opts.bootstrapSource(opts, events)
  })

  it.skip('should create a new tree_placement record', function (done) {
    this.timeout(64000)

    opts.bot.handler(opts.event, opts.createContext(), (err, _) => {
      if (err) done(err)
      else {
        assert(true)

        done()
      }
    })
  })
}
