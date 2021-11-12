'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [{
    _event: 'DEALERSHIP_CREATED',
    client_user_id: '1234',
    first_name: 'Stampin',
    last_name: 'Up!',
    email: 'donotship@donotship.com',
    home_phone: '8000026787',
    mobile_phone: '',
    address: 'Do Not Ship',
    address2: '',
    city: 'Do Not Ship',
    postal_code: '84105',
    country: 'US',
    signup_date: '2004-04-19',
    birth_date: '1988-01-01',
    company_name: 'Up!, Stampin',
    rank: {
      id: '1',
      description: 'Bronze'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    upline: {
      client_sponsor_id: '0'
    },
    extra: {
      is_subscriber: false
    },
    icentris_client: 'stampinup'
  }, {
    _event: 'DEALERSHIP_CREATED',
    client_user_id: '3456',
    first_name: 'Mash',
    last_name: 'Up!',
    email: 'comeonship@donotship.com',
    home_phone: '9830026787',
    mobile_phone: '',
    address: 'Come on Ship',
    address2: '',
    city: 'Come on Ship',
    postal_code: '84105',
    country: 'US',
    signup_date: '2004-04-19',
    birth_date: '1988-01-01',
    company_name: 'Up!, Mash',
    rank: {
      id: '2',
      description: 'Gold'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    upline: {
      client_sponsor_id: '0'
    },
    extra: {
      is_subscriber: false
    },
    icentris_client: 'stampinup'
  }]

  const expectedOutputs = [{
    _event: 'DEALERSHIP_CREATED',
    client_user_id: '1234',
    first_name: 'Stampin',
    last_name: 'Up!',
    email: 'icentris.qa6+1234@gmail.com',
    home_phone: '1111111111',
    mobile_phone: '1111111111',
    address: 'Do Not Ship',
    address2: '',
    city: 'Do Not Ship',
    postal_code: '84105',
    country: 'US',
    signup_date: '2004-04-19',
    birth_date: '1988-01-01',
    company_name: 'Up!, Stampin',
    rank: {
      client_level: '1',
      name: 'Bronze'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    upline: {
      client_sponsor_id: '0'
    },
    extra: {
      is_subscriber: false
    },
    icentris_client: 'stampinup'
  }, {
    _event: 'DEALERSHIP_CREATED',
    client_user_id: '3456',
    first_name: 'Mash',
    last_name: 'Up!',
    email: 'icentris.qa6+3456@gmail.com',
    home_phone: '1111111111',
    mobile_phone: '1111111111',
    address: 'Come on Ship',
    address2: '',
    city: 'Come on Ship',
    postal_code: '84105',
    country: 'US',
    signup_date: '2004-04-19',
    birth_date: '1988-01-01',
    company_name: 'Up!, Mash',
    rank: {
      client_level: '2',
      name: 'Gold'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    upline: {
      client_sponsor_id: '0'
    },
    extra: {
      is_subscriber: false
    },
    icentris_client: 'stampinup'
  }]

  beforeEach(() => {
    bot = opts.getBot('load/ingress-proxy/user')
    opts.bus.inQueueData = sampleInputs
  })

  describe('#handle', function () {
    it('verifies that ranks are properly mapped', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutput0 = opts.bus.outQueueData[0].payload
      const actualOutput1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(actualOutput0.rank, expectedOutputs[0].rank)
      assert.deepEqual(actualOutput1.rank, expectedOutputs[1].rank)
    })
    it('ensures masking is in place for tst environment', async function () {
      this.timeout(5000)

      const origEnv = process.env.NODE_ENV
      process.env.NODE_ENV = 'tst'

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutput0 = opts.bus.outQueueData[0].payload
      const actualOutput1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(actualOutput0.email, expectedOutputs[0].email)
      assert.deepEqual(actualOutput1.email, expectedOutputs[1].email)

      process.env.NODE_ENV = origEnv
    })
  })
}
