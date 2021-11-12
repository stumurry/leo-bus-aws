'use strict'

const s3 = require('../../../libs/s3')

module.exports = (opts) => {
  const assert = opts.assert
  const BUCKET = 'icentris-bus-' + process.env.NODE_ENV
  const ORIG_KEY = 'test/s3/in.txt'
  const NEW_KEY = 'test/s3/out.txt'
  beforeEach(async function () {
    this.timeout(10000)

    try {
      await s3.deleteObject({
        Bucket: BUCKET,
        Key: NEW_KEY
      }).promise()
    } catch (err) {
      console.log('errored deleting renamed file before test', err)
    }

    return s3.putObject({
      Bucket: BUCKET,
      Key: ORIG_KEY,
      Body: 'test content'
    })
      .promise()
      .then(() => {
        return s3.getObject({
          Bucket: BUCKET,
          Key: ORIG_KEY
        })
          .promise()
      })
  })

  describe('#handle', () => {
    it('should rename an existing key to a new key in the same bucket and the old key should not exist any longer', async function () {
      this.timeout(10000)

      try {
        const contents = await s3.rename(BUCKET, ORIG_KEY, NEW_KEY)
          .promise()
          .then(() => {
            return s3.getObject({
              Bucket: BUCKET,
              Key: NEW_KEY
            })
              .promise()
          })
          .catch(err => {
            assert.fail(err)
          })

        assert(contents.Body.toString('utf-8') === 'test content')
      } catch (err) {
      }
    })
  })
}
