'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const expectedInputs = [{
    icentris_client: 'bluesun',
    client_user_id: 'd1111',
    first_name: 'John',
    last_name: 'Wick',
    email: 'john.wick@assassinsr.us',
    home_phone: '5556789432',
    fax_phone: '5551235543',
    mobile_phone: '5555554321',
    address: '123 Easy Street',
    address2: 'Ste 500',
    city: 'Metropolis',
    state: 'KS',
    postal_code: '84302',
    county: 'Nowhere',
    country: 'US',
    signup_date: '03/01/2003 10:00:00',
    birth_date: '12/02/1982',
    company_name: 'Assassins R US',
    rank: {
      client_level: '1',
      name: 'Member'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    upline: {
      client_sponsor_id: 'd666', // sponsor dealership id
      client_parent_id: 'd888',
      parent_position: 1,
      sponsor_position: 0,
      parent_level: 15,
      sponsor_level: 10
    },
    extra: {
      sponsor_dealer_id: '777',
      sponsor_dealership_id: '666',
      dealer_id: '2222',
      dealership_id: '1111',
      parent_dealer_id: '999',
      parent_dealership_id: '888'
    },
    is_downline_contact: true
  }, {
    icentris_client: 'bluesun',
    client_user_id: 'd1112',
    first_name: 'Abe',
    last_name: 'Lincoln',
    email: 'abe@test.com',
    home_phone: '5556789433',
    fax_phone: '5551235544',
    mobile_phone: '5555554322',
    address: '1999 Broadway',
    address2: 'Ste 501',
    city: 'Denver',
    state: 'CO',
    postal_code: '80202',
    county: 'Denver',
    country: 'US',
    signup_date: '2003-03-02 10:00:01',
    birth_date: '1982-12-03',
    company_name: 'Quandary',
    rank: {
      client_level: '2',
      name: 'Rust'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    upline: {
      client_sponsor_id: 'd667',
      client_parent_id: 'd889',
      parent_position: 0,
      sponsor_position: 1,
      parent_level: 8,
      sponsor_level: 9
    },
    extra: {
      dealer_id: '2223',
      dealership_id: '1112',
      sponsor_dealer_id: '778',
      sponsor_dealership_id: '667',
      parent_dealer_id: '990',
      parent_dealership_id: '889'
    },
    is_downline_contact: true
  }]

  const expectedOutputs = [{
    icentris_client: 'bluesun',
    client_user_id: 'd1111',
    first_name: 'John',
    last_name: 'Wick',
    email: 'john.wick@assassinsr.us',
    home_phone: '5556789432',
    fax_phone: '5551235543',
    mobile_phone: '5555554321',
    address: '123 Easy Street',
    address2: 'Ste 500',
    city: 'Metropolis',
    state: 'KS',
    postal_code: '84302',
    county: 'Nowhere',
    country: 'US',
    signup_date: '2003-03-01 15:00:00',
    birth_date: '1982-12-02 05:00:00',
    company_name: 'Assassins R US',
    rank: {
      client_level: '1',
      name: 'Member'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    upline: {
      client_sponsor_id: 'd666', // sponsor dealership id
      client_parent_id: 'd888',
      parent_position: 1,
      sponsor_position: 0,
      parent_level: 15,
      sponsor_level: 10
    },
    extra: {
      sponsor_dealer_id: '777',
      sponsor_dealership_id: '666',
      dealer_id: '2222',
      dealership_id: '1111',
      parent_dealer_id: '999',
      parent_dealership_id: '888'
    },
    is_downline_contact: true
  }, {
    icentris_client: 'bluesun',
    client_user_id: 'd1112',
    first_name: 'Abe',
    last_name: 'Lincoln',
    email: 'abe@test.com',
    home_phone: '5556789433',
    fax_phone: '5551235544',
    mobile_phone: '5555554322',
    address: '1999 Broadway',
    address2: 'Ste 501',
    city: 'Denver',
    state: 'CO',
    postal_code: '80202',
    county: 'Denver',
    country: 'US',
    signup_date: '2003-03-02 15:00:01',
    birth_date: '1982-12-03 05:00:00',
    company_name: 'Quandary',
    rank: {
      client_level: '2',
      name: 'Rust'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    type: {
      id: '2',
      description: 'Distributor'
    },
    upline: {
      client_sponsor_id: 'd667',
      client_parent_id: 'd889',
      parent_position: 0,
      sponsor_position: 1,
      parent_level: 8,
      sponsor_level: 9
    },
    extra: {
      dealer_id: '2223',
      dealership_id: '1112',
      sponsor_dealer_id: '778',
      sponsor_dealership_id: '667',
      parent_dealer_id: '990',
      parent_dealership_id: '889'
    },
    is_downline_contact: true
  }]

  beforeEach(() => {
    bot = opts.getBot('plmb/utc_transform/user')
    opts.bus.inQueueData = expectedInputs
  })

  describe('#handle', function () {
    it('puts proper data on outQueue', async function () {
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
