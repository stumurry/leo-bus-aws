'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [
    {
      _event: 'dealer_updated',
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
      _event: 'dealer_updated',
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
      customer_type: {
        id: '2', // **THIS WAS AN INTEGER IN ORIGINAL FEPS BUT
        // WE ARE ASSUMING IT WILL BE A STRING**
        description: 'Bonus Customer'
      },
      birth_date: '1981-12-02',
      sponsor: {
        dealership_id: '5000',
        dealer_id: '100'
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
      upline: {
        client_sponsor_id: 'd1234'
      // "client_sponsor_id": "",
      },
      extra: {
        dealer_id: '1234',
        sponsor_dealer_id: '123',
        sponsor_dealership_id: '1234'
      },
      is_downline_contact: false
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
      birth_date: '1981-12-02',
      company_name: 'Broadwing',
      type: {
        id: '2',
        description: 'Bonus Customer'
      },
      upline: {
        client_sponsor_id: 'd5000'
      },
      extra: {
        dealer_id: '1235',
        sponsor_dealer_id: '100',
        sponsor_dealership_id: '5000'
      },
      is_downline_contact: true
    }
  ]

  beforeEach(() => {
    bot = opts.getBot('load/trinity/dealer_updated')
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

    it('loads dealership for each id in the dealership_ids array', async function () {
      this.timeout(5000)

      // Just send 1 event for this test
      sampleInputs.splice(-1, 2)
      expectedOutputs.splice(-1, 2)

      // Add 'dealership_ids' array to payload
      Object.assign(sampleInputs[0], { dealership_ids: ['1', '2', '3'] })

      await bot.handle(opts.event, opts.context)

      // console.log(JSON.stringify(opts.bus.inQueueData, null, 2))
      // console.log(JSON.stringify(opts.bus.outQueueData, null, 2))
      assert.strictEqual(opts.bus.outQueueData.length, 3)

      // We expect the output to contain a different client_user_id, type, and extra.dealership_id
      const expectedOutput0 = Object.assign(expectedOutputs[0], { client_user_id: 'd1', type: { id: 2, description: 'Distributor' } })
      Object.assign(expectedOutput0.extra, { dealership_id: '1' })
      assert.deepEqual(opts.bus.outQueueData[0].payload, expectedOutput0)
    })
  })
}
