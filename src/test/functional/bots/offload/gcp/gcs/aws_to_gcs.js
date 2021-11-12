'use strict'

module.exports = (opts) => {
  const awsBucket = `icentris-gcp-${process.env.NODE_ENV}`

  before((done) => {
    opts = opts.setOptsForBot('offload/gcp/gcs', opts)

    const events = [{
      Key: 'vibe-contact-categories-final-08637b8b3d7f0d8c7e6e21ecf6d2fd593b408b18b3ca873031ef106a7e9ff0f4-1586675643127',
      Bucket: awsBucket
    }]

    done()

    return opts.bootstrapSource(opts, events)
  })

  describe.skip('#Run Payloads', () => {
    it('should test for file created in gcs', async () => {
      await opts.bot.handle(opts.event, opts.context)
    }).timeout(86400000)
  })
}
