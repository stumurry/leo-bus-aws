'use strict'
const aws = require('aws-sdk')
const s3 = new aws.S3()
const leoUtils = require('../../../../../utils/leo_utils')

module.exports = (opts) => {
  const assert = opts.assert
  const bucket = `icentris-gcp-${process.env.NODE_ENV}`

  const truncateBucket = async () => {
    const s3List = (await s3.listObjectsV2({ Bucket: bucket }).promise()).Contents
    s3List.forEach(async s => { if (s.Key.includes(opts.event.source)) await s3.deleteObject({ Bucket: bucket, Key: s.Key }).promise() })
  }

  // This test is is deprecated as this variation no longer exists.
  // before((done) => {
  //   opts = opts.setOptsForBot('offload/s3', opts, 'ContactCategories')
  //   const events = []

  //   events.push({
  //     id: 1,
  //     category_name: 'phone',
  //     user_id: null,
  //     status: null,
  //     created_at: '2019-01-26T17:34:26.000Z',
  //     updated_at: '2020-04-02T09:32:47.000Z',
  //     contacts_count: 8629539,
  //     icentris_client: 'worldventures'
  //   })

  //   done()

  //   return truncateBucket().then(() => { return opts.bootstrapSource(opts, events) })
  // })

  describe.skip('#Run Payloads', () => {
    it.skip('should test for file created in s3', async () => {
      function timeout (ms) {
        return new Promise(resolve => setTimeout(resolve, ms))
      }

      await timeout(3000) // Wait a little so bus has time to catch up.
      await opts.bot.handle(opts.event, opts.context)
      await timeout(3000)

      var s3List = (await s3.listObjectsV2({ Bucket: bucket }).promise()).Contents
      var destinationPayloads = await leoUtils.offloadDestinationQueue(opts.bus.leo, opts.event.destination)

      // If there is an error during testing, you may need to run it twice so the checkpoint can catches up.
      assert.equal(destinationPayloads.length, 1, `destination queue ${opts.event.destination} should contain only 1 payload.  Found ${destinationPayloads.length}`)

      var s3Objects = s3List.filter(s => s.Key.includes(opts.event.source))
      assert.equal(s3Objects.length, 1, `1 file should be uploaded to s3 bucket: ${bucket}. Found ${s3Objects.length}`)

      await truncateBucket()

      await timeout(3000) // Wait a little so bus has time to catch up.
      await opts.bot.handle(opts.event, opts.context)
      await timeout(3000) // Wait a little so bus has time to catch up.

      destinationPayloads = await leoUtils.offloadDestinationQueue(opts.bus.leo, opts.event.destination)
      assert.equal(destinationPayloads.length, 0, `There should be no event payload outputted on no-data.  Found ${destinationPayloads.length} payload.`)

      s3List = (await s3.listObjectsV2({ Bucket: bucket }).promise()).Contents
      s3Objects = s3List.filter(s => s.Key.includes(opts.event.queue))
      assert.equal(s3Objects.length, 1, `No file should be uploaded to s3 bucket: ${bucket}, with no data. Found ${s3Objects.length} file(s).`)
    }).timeout(86400000)
  })
}
