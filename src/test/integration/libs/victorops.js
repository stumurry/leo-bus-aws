
module.exports = (opts) => {
  const rewire = require('rewire')
  const victorops = rewire('../../../libs/victorops')
  const assert = opts.assert
  const sinon = opts.sinon
  const request = require('superagent')

  describe('#victorops', function () {
    it('writeToVictorOps', function () {
      const post = {
        type: (arg) => post,
        send: (arg) => post
      }

      sinon.stub(request, 'post')
        .callsFake((url) => post)

      const typeSpy = sinon.spy(post, 'type')
      const sendSpy = sinon.spy(post, 'send')

      const config = {
        url: 'http://icentris.com'
      }

      const p = {}

      victorops.__set__('victorOpsRequest', (payload) => p)
      victorops.writeToVictorOps(config, p)

      assert(request.post.calledWith(config.url))
      assert(typeSpy.calledWith('application/json'))
      assert(sendSpy.calledWith(p))
    })

    it('victorOpsRequest', function () {
      const payload = {
        entity_id: 1,
        message: 'a message'
      }

      const expectedPayload = {
        message_type: 'CRITICAL',
        entity_id: 1,
        entity_display_name: `CDC Checkpoint Error - leo-bus-${process.env.NODE_ENV}`,
        state_message: 'a message'
      }
      const requestPayload = victorops.victorOpsRequest(payload)
      // console.log(requestPayload)

      assert.equal(requestPayload, JSON.stringify(expectedPayload))
    })
  })
}
