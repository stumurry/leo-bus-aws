'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [{
    _event: 'DEALERSHIP_OWNERSHIPTRANSFER',
    icentris_client: 'bluesun',
    dealership_id: '1234',
    dealer: {
      dealer_id: '1234',
      first_name: 'John',
      last_name: 'Wick',
      company_name: 'Assassins R US',
      home_phone: '555-555-1234',
      fax_phone: '555-123-5543',
      mobile_phone: '555-555-4321',
      email: 'john.wick@assassinsr.us',
      address1: '123 Easy Street',
      address2: 'Ste 103',
      city: 'Metropolis',
      state: 'KS',
      postal_code: '84302',
      county: 'Nowhere',
      country: 'US',
      signup_date: '2018-01-01 23:59:58',
      birth_date: '1982-12-02'
    },
    sponsor: {
      dealership_id: '123',
      dealer_id: '123'
    },
    enroller: {
      dealership_id: '1',
      dealer_id: '2'
    }
  },
  {
    _event: 'DEALERSHIP_OWNERSHIPTRANSFER',
    icentris_client: 'bluesun',
    dealership_id: '1235',
    dealer: {
      dealer_id: '1236',
      first_name: 'Paul',
      last_name: 'Wick',
      company_name: 'Assassins R US',
      home_phone: '555-555-1235',
      fax_phone: '555-123-5545',
      mobile_phone: '555-555-4325',
      email: 'paul.wick@assassinsr.us',
      address1: '125 Easy Street',
      address2: 'Ste 105',
      city: 'Metropolis',
      state: 'KS',
      postal_code: '84111',
      county: 'Nowhere',
      country: 'USA',
      signup_date: '2015-01-01 23:59:58',
      birth_date: '1985-12-02'
    },
    sponsor: {
      dealership_id: '124',
      dealer_id: '125'
    },
    enroller: {
      dealership_id: '3',
      dealer_id: '4'
    }
  }]

  const expectedOutputs = [{
    // 'icentris_client': 'liu',
    // 'tree_user_id': '',
    // 'user_id': '',
    // 'rank_id': '',
    // 'type_id': '',
    // 'status_id': '',
    client_user_id: 'd1234',
    icentris_client: 'bluesun',
    first_name: 'John',
    last_name: 'Wick',
    email: 'john.wick@assassinsr.us',
    home_phone: '5555551234',
    fax_phone: '5551235543',
    mobile_phone: '5555554321',
    address: '123 Easy Street',
    address2: 'Ste 103',
    city: 'Metropolis',
    state: 'KS',
    postal_code: '84302',
    county: 'Nowhere',
    country: 'US',
    signup_date: '2018-01-01 23:59:58',
    birth_date: '1982-12-02',
    company_name: 'Assassins R US',
    upline: {
      // 'parent_id': '',
      // 'sponsor_id': '',
      // 'client_upline_id': '2345',
      client_sponsor_id: 'd123', // sponsor dealership id
      client_parent_id: 'd1'
    },
    extra: {
      // '_comment': 'Client specific addon fields'
      sponsor_dealer_id: '123',
      sponsor_dealership_id: '123',
      dealer_id: '1234',
      dealership_id: '1234',
      parent_dealer_id: '2',
      parent_dealership_id: '1'
    }
  },
  {
    // 'icentris_client': 'liu',
    // 'tree_user_id': '',
    // 'user_id': '',
    // 'rank_id': '',
    // 'type_id': '',
    // 'status_id': '',
    icentris_client: 'bluesun',
    client_user_id: 'd1235',
    first_name: 'Paul',
    last_name: 'Wick',
    email: 'paul.wick@assassinsr.us',
    home_phone: '5555551235',
    fax_phone: '5551235545',
    mobile_phone: '5555554325',
    address: '125 Easy Street',
    address2: 'Ste 105',
    city: 'Metropolis',
    state: 'KS',
    postal_code: '84111',
    county: 'Nowhere',
    country: 'US',
    signup_date: '2015-01-01 23:59:58',
    birth_date: '1985-12-02',
    company_name: 'Assassins R US',
    upline: {
      // 'parent_id': '',
      // 'sponsor_id': '',
      // 'client_upline_id': '2345',
      client_sponsor_id: 'd124', // sponsor dealership id
      client_parent_id: 'd3'
    },
    extra: {
      // '_comment': 'Client specific addon fields'
      sponsor_dealer_id: '125',
      sponsor_dealership_id: '124',
      dealer_id: '1236',
      dealership_id: '1235',
      parent_dealer_id: '4',
      parent_dealership_id: '3'
    }
  }
  ]

  beforeEach(() => {
    bot = opts.getBot('load/trinity/dealership_ownership_transfer')
    opts.bus.inQueueData = sampleInputs
  })

  describe('#handle', function () {
    it('hope putsss proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutput0 = opts.bus.outQueueData[0].payload
      const actualOutput1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(actualOutput0, expectedOutputs[0])
      assert.deepEqual(actualOutput1, expectedOutputs[1])
    })
  })
}
