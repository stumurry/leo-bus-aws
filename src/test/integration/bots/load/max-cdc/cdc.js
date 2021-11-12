'use strict'

module.exports = (opts) => {
  // const rewire = require('rewire')
  // const maxcdc = rewire('../../../../../libs/maxcdc')
  const maxcdc = require('../../../../../libs/maxcdc')
  const through2 = require('through2')
  const stream = require('stream')
  const sinon = opts.sinon
  const assert = opts.assert
  let bot

  before(() => {
    opts.event.icentris_client = 'bluesun'

    const checkpoint = {

    }

    opts.bus.leo.bot.getCheckpoint = async (src) => {
      return JSON.stringify(checkpoint)
    }

    opts.event.tables = [
      'tree_zleads'
    ]
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach((done) => {
    const pp = async () => {
      bot = opts.getBot('load/max-cdc')
      bot.useS3 = false

      opts.event.icentris_client = 'bluesun'
    }

    pp().then(done).catch(done)
  })

  describe('#handle', function () {
    it('test cdc', (done) => {
      const pp = async () => {
        const streamChanges = new stream.Readable({
          read () { }
        })

        const expected = { msg: 'Simple test to test if streams are connected properly.' }
        streamChanges.push(JSON.stringify(expected))
        streamChanges.push(null)
        sinon.stub(maxcdc, 'streamChanges')
          .callsFake((tables, checkpoints, maxCdcCfg) => streamChanges)

        const formatPayload = through2((chunk, enc, callback) => {
          callback(null, chunk)
        })
        sinon.stub(maxcdc, 'formatPayload')
          .callsFake((tables) => formatPayload)

        await bot.handle(opts.event, opts.context)

        const out = opts.bus.outQueueData

        assert.deepEqual(JSON.parse(out[0].payload), expected)
      }
      pp().then(done).catch(done)
    })
  })
}
