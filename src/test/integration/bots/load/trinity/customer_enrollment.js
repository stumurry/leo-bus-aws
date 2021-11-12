'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [
    {
      _event: 'CUSTOMER_ENROLLMENT',
      icentris_client: 'bluesun',
      dealer_id: '1234',
      first_name: 'First',
      last_name: 'Last',
      company_name: 'Acme Co',
      home_phone: '555-555-1234',
      fax_phone: '555-123-5543',
      mobile_phone: '555-555-4321',
      email: 'test@example.com',
      address1: '123 Easy Street',
      address2: 'Ste 103',
      city: 'Saratoga Springs',
      state: 'UT',
      postal_code: '84045',
      county: 'Utah',
      country: 'USA',
      signup_date: '2018-01-01 23:59:58',
      customer_type: {
        id: '1', // **THIS WAS AN INTEGER IN ORIGINAL FEPS BUT
        // WE ARE ASSUMING IT WILL BE A STRING**
        description: 'Retail Customer'
      },
      birth_date: '1982-12-02',
      sponsor: {
        dealership_id: '1234',
        dealer_id: '123'
      }
    },
    {
      _event: 'CUSTOMER_ENROLLMENT',
      icentris_client: 'bluesun',
      dealer_id: '1235',
      first_name: 'Abe',
      last_name: 'Lincoln',
      company_name: 'Broadwing',
      home_phone: '555-555-1237',
      fax_phone: '555-123-5541',
      mobile_phone: '555-555-4320',
      email: 'example@test.com',
      address1: '123 Mill Ave',
      address2: '#5',
      city: 'Denver',
      state: 'CO',
      postal_code: '80202',
      county: 'Denver',
      country: 'USA',
      signup_date: '2018-01-01 23:59:59',
      birth_date: '1981-12-02 00:00:00',
      sponsor: {
        dealership_id: '5000',
        dealer_id: '100'
      },
      status: {
        id: '1',
        description: 'Active'
      }
    }
  ]

  const expectedOutputs = [
    {
      // "type_id": "",
      icentris_client: 'bluesun',
      client_user_id: 'c1234',
      first_name: 'First',
      last_name: 'Last',
      email: 'test@example.com',
      home_phone: '5555551234',
      mobile_phone: '5555554321',
      fax_phone: '5551235543',
      address: '123 Easy Street',
      address2: 'Ste 103',
      city: 'Saratoga Springs',
      state: 'UT',
      postal_code: '84045',
      county: 'Utah',
      country: 'US',
      signup_date: '2018-01-01 23:59:58',
      birth_date: '1982-12-02',
      company_name: 'Acme Co',
      type: {
        id: '1',
        description: 'Retail Customer'
      },
      status: {
        id: '1',
        description: 'Active'
      },
      upline: {
        client_sponsor_id: 'd1234'
      // "client_sponsor_id": "",
      },
      extra: {
        dealer_id: '1234',
        sponsor_dealer_id: '123',
        sponsor_dealership_id: '1234'
      }
    },
    {
      // "type_id": "",
      icentris_client: 'bluesun',
      client_user_id: 'c1235',
      first_name: 'Abe',
      last_name: 'Lincoln',
      email: 'example@test.com',
      home_phone: '5555551237',
      mobile_phone: '5555554320',
      address: '123 Mill Ave',
      address2: '#5',
      city: 'Denver',
      state: 'CO',
      fax_phone: '5551235541',
      postal_code: '80202',
      county: 'Denver',
      country: 'US',
      signup_date: '2018-01-01 23:59:59',
      birth_date: '1981-12-02 00:00:00',
      company_name: 'Broadwing',
      type: {
        id: '2',
        description: 'Distributor'
      },
      status: {
        id: '1',
        description: 'Active'
      },
      upline: {
        client_sponsor_id: 'd5000'
      },
      extra: {
        dealer_id: '1235',
        sponsor_dealer_id: '100',
        sponsor_dealership_id: '5000'
      }
    }
  ]

  beforeEach(() => {
    bot = opts.getBot('load/trinity/customer_enrollment')
    opts.bus.inQueueData = sampleInputs
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
