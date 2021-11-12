'use strict'

module.exports = (opts) => {
  const assert = opts.assert

  beforeEach(async () => {
    opts.configureOpts('vibe/jobs')
  })

  describe.skip('#handler', () => {
    it('should get a job_id for bluesun->create_vibe_accounts.json ', function (done) {
      opts.bot.handler(opts.event, opts.createContext(), (err, data) => {
        if (err) done(err)
        else {
          assert.equal(data.length, 1)
          assert.equal(data[0].client, 'bluesun')
          assert.equal(data[0].job, 'create_vibe_accounts.json')
          assert(data[0].job_id)
          done()
        }
      })
    })
  })
}
