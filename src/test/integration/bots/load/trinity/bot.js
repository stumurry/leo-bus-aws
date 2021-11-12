'use strict'

module.exports = (opts) => {
  const TrinityLoader = require('../../../../../bots/load/trinity/bot')
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    bot = new TrinityLoader(opts.bus)
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [{
        dealer_id: '1234',
        icentris_client: 'bluesun',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '9/1/2018 5:09:41 AM'
      }, {
        dealer_id: '1235',
        icentris_client: 'bluesun',
        first_name: 'Abe',
        last_name: 'Lincoln',
        company_name: 'Broadwing',
        signup_date: '12/12/2017 12:09:41 PM'
      }]
    })

    it('passes empty objects if given empty whitelists', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(Object.keys(out0).length, 1)
      assert.strictEqual(Object.keys(out1).length, 1)
    })

    it('passes data through unchanged by default', async function () {
      this.timeout(5000)

      const in0 = opts.bus.inQueueData[0]
      const in1 = opts.bus.inQueueData[1]

      // define an attribute whitelist to match sample data (normally
      // will be defined by subclass)
      bot.whiteList = Object.keys(in0).slice(1, 3)

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      bot.whiteList.forEach((oldKey) => {
        assert.strictEqual(in0[oldKey], out0[oldKey])
        assert.strictEqual(in1[oldKey], out1[oldKey])
      })
    })

    // this prevents us from writing "undefined" as a outbound property
    it('ignores undefined values', async function () {
      bot.whiteList = ['molasses']

      assert.strictEqual(typeof opts.bus.inQueueData[0].molasses, 'undefined')

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload

      const badkeyPresent = Object.keys(out0).includes(key => key === 'molasses')
      assert.strictEqual(badkeyPresent, false)
    })

    it('uses custom transform if available', async function () {
      this.timeout(5000)

      const in0 = opts.bus.inQueueData[0]

      // define an attribute whitelist to match sample data (normally
      // will be defined by subclass)
      bot.whiteList = Object.keys(in0)

      // define a custom mapper (normally would be defined by subclass
      TrinityLoader.prototype.firstNameReducer = (keyIn, objIn, objOut) => {
        objOut.name0 = 'Johnny'
        return objOut
      }

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      // make sure transformed keys/values are there
      assert.strictEqual(out0.name0, 'Johnny')
      assert.strictEqual(out1.name0, 'Johnny')

      // and that the original key names were not passed through
      assert.strictEqual(typeof out0.first_name, 'undefined')
      assert.strictEqual(typeof out1.first_name, 'undefined')

      TrinityLoader.prototype.firstNameReducer = undefined
    })

    describe('handles *_date attributes properly', () => {
      beforeEach(() => {
        const in0 = opts.bus.inQueueData[0]
        bot.whiteList = Object.keys(in0)
      })

      it('whitelists *_date attributes', async () => {
        assert.strictEqual(bot.whiteList.includes('signup_date'), true)
      })
    })
  }) // describe '#handle'

  describe('dealer_id and dealership_id', function () {
    it('maps dealer_id to client_user_id prepending with c', async function () {
      opts.bus.inQueueData = [
        {
          dealer_id: '3015',
          icentris_client: 'bluesun'
        }
      ]
      bot.whiteList = ['dealer_id']

      const expectedOut = {
        client_user_id: 'c3015',
        icentris_client: 'bluesun',
        extra: {
          dealer_id: '3015'
        }
      }

      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const objectOut = opts.bus.outQueueData[0].payload
      assert.deepEqual(objectOut, expectedOut)
    })

    it('maps dealership_id to client_user_id prepending with d', async function () {
      opts.bus.inQueueData = [
        {
          icentris_client: 'bluesun',
          dealership_id: '3985'
        }
      ]
      bot.whiteList = ['dealership_id']

      const expectedOut = {
        client_user_id: 'd3985',
        icentris_client: 'bluesun',
        extra: {
          dealership_id: '3985'
        }
      }

      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const objectOut = opts.bus.outQueueData[0].payload
      assert.deepEqual(expectedOut, objectOut)
    })

    it('places dealer_id in the "extra" object if both dealer_id and dealership_id are present in the event and dealership is not null and not 0', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        dealership_id: '1111',
        dealer_id: '7777'
      }]

      bot.whiteList = ['dealership_id', 'dealer_id']

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const objectOut = opts.bus.outQueueData[0].payload

      assert.strictEqual(objectOut.dealership_id, undefined)
      assert.strictEqual(objectOut.dealer_id, undefined)
      assert.strictEqual(objectOut.client_user_id, 'd1111')
      assert.strictEqual(objectOut.extra.dealer_id, '7777')
    })
  })

  describe('data anonymizes data for tst environment', function () {
    it('Masks email when env is tst', function () {
      const objIn = { email: 'email.test@bluesun.com' }
      const objOut = {}
      const nEnv = process.env.NODE_ENV
      process.env.NODE_ENV = 'tst'
      bot.emailReducer('email', objIn, objOut)
      process.env.NODE_ENV = nEnv
      assert.strictEqual('icentris.qa6+email.test@gmail.com', objOut.email)
    })

    it('Does not mask email when env is not tst', function () {
      const objIn = { email: 'email.test@bluesun.com' }
      const objOut = {}
      bot.emailReducer('email', objIn, objOut)
      assert.strictEqual(objIn.email, objOut.email)
    })

    it('Masks phone numbers when env is tst', function () {
      const objIn = { home_phone: '123-123-1234', mobile_phone: '234-234-2345', fax_phone: '456-456-4567' }
      const objOut = {}
      const nEnv = process.env.NODE_ENV
      process.env.NODE_ENV = 'tst'
      bot.homePhoneReducer('home_phone', objIn, objOut)
      bot.mobilePhoneReducer('mobile_phone', objIn, objOut)
      bot.faxPhoneReducer('fax_phone', objIn, objOut)
      process.env.NODE_ENV = nEnv
      assert.strictEqual('1111111111', objOut.home_phone)
      assert.strictEqual('1111111111', objOut.mobile_phone)
      assert.strictEqual('1111111111', objOut.fax_phone)
    })

    it('Does not mask phone numbers when env is not tst', function () {
      const objIn = { home_phone: '123-123-1234', mobile_phone: '234-234-2345', fax_phone: '456-456-4567' }
      const objOut = {}
      bot.homePhoneReducer('home_phone', objIn, objOut)
      bot.mobilePhoneReducer('mobile_phone', objIn, objOut)
      bot.faxPhoneReducer('fax_phone', objIn, objOut)
      assert.strictEqual('1231231234', objOut.home_phone)
      assert.strictEqual('2342342345', objOut.mobile_phone)
      assert.strictEqual('4564564567', objOut.fax_phone)
    })
  })
}
