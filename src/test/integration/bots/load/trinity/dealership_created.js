'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInputs = [{
    _event: 'DEALERSHIP_CREATED',
    icentris_client: 'bluesun',
    dealership_id: '1111',
    dealer: {
      dealer_id: '2222',
      first_name: 'John',
      last_name: 'Wick',
      company_name: 'Assassins R US',
      home_phone: '555-678-9432',
      fax_phone: '555-123-5543',
      mobile_phone: '555-555-4321',
      email: 'john.wick@assassinsr.us',
      address1: '123 Easy Street',
      address2: 'Ste 500',
      city: 'Metropolis',
      state: 'KS',
      postal_code: '84302',
      county: 'Nowhere',
      country: 'USA',
      signup_date: '03/01/2003 10:00:00',
      birth_date: '12/02/1982'
    },
    rank: {
      id: '1',
      description: 'Member'
    },
    sponsor: {
      dealership_id: '666',
      dealer_id: '777',
      position: 0,
      level: 10
    },
    enroller: {
      dealership_id: '888',
      dealer_id: '999',
      position: 1,
      level: 15
    }
  }, {
    _event: 'DEALERSHIP_CREATED',
    icentris_client: 'bluesun',
    dealership_id: '1112',
    dealer: {
      dealer_id: '2223',
      first_name: 'Abe',
      last_name: 'Lincoln',
      company_name: 'Quandary',
      home_phone: '555-678-9433',
      fax_phone: '555-123-5544',
      mobile_phone: '555-555-4322',
      email: 'abe@test.com',
      address1: '1999 Broadway',
      address2: 'Ste 501',
      city: 'Denver',
      state: 'CO',
      postal_code: '80202',
      county: 'Denver',
      country: 'USA',
      signup_date: '2003-03-02 10:00:01',
      birth_date: '1982-12-03'
    },
    rank: {
      id: '2',
      description: 'Rust'
    },
    status: {
      id: '1',
      description: 'Active'
    },
    sponsor: {
      dealership_id: '667',
      dealer_id: '778',
      position: 1,
      level: 9
    },
    enroller: {
      dealership_id: '889',
      dealer_id: '990',
      position: 0,
      level: 8
    }
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

  beforeEach(() => {
    bot = opts.getBot('load/trinity/dealership_created')
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

    it('updates dealer to dealership if tree_user exists', async () => {
      await opts.mysql.truncate('tree_users')
      await opts.mysql.truncate('users')

      // Insert tree_user and user
      const treeUserId = await opts.mysql.execute(`INSERT INTO tree_users(client_user_id) VALUES('c${opts.bus.inQueueData[0].dealer.dealer_id}')`).then(rs => rs[0].insertId)
      const userId = await opts.mysql.execute(`INSERT INTO users(tree_user_id, consultant_id) VALUES(${treeUserId}, 'c${opts.bus.inQueueData[0].dealer.dealer_id}')`).then(rs => rs[0].insertId)

      // Retrieve tree_user and user and test results
      const beforeRs = await opts.mysql.execute(`SELECT tu.id tree_user_id, tu.client_user_id, u.id user_id, u.consultant_id FROM tree_users tu INNER JOIN users u on tu.id = u.tree_user_id WHERE tu.client_user_id = 'c${opts.bus.inQueueData[0].dealer.dealer_id}'`).then(rs => rs[0][0])
      assert.strictEqual(beforeRs.tree_user_id, treeUserId)
      assert.strictEqual(beforeRs.client_user_id, `c${opts.bus.inQueueData[0].dealer.dealer_id}`)
      assert.strictEqual(beforeRs.user_id, userId)
      assert.strictEqual(beforeRs.consultant_id, `c${opts.bus.inQueueData[0].dealer.dealer_id}`)

      await bot.handle(opts.event, opts.context)

      // Retrieve tree_user and user and test results
      const afterRs = await opts.mysql.execute(`SELECT tu.id tree_user_id, tu.client_user_id, u.id user_id, u.consultant_id FROM tree_users tu INNER JOIN users u on tu.id = u.tree_user_id WHERE tu.id = ${treeUserId}`).then(rs => rs[0][0])
      assert.strictEqual(afterRs.tree_user_id, treeUserId)
      assert.strictEqual(afterRs.client_user_id, `d${opts.bus.inQueueData[0].dealership_id}`)
      assert.strictEqual(afterRs.user_id, userId)
      assert.strictEqual(afterRs.consultant_id, `d${opts.bus.inQueueData[0].dealership_id}`)
    })

    it('masks phone and email in tst', async function () {
      this.timeout(5000)
      const nEnv = process.env.NODE_ENV
      process.env.NODE_ENV = 'tst'
      await bot.handle(opts.event, opts.context)
      process.env.NODE_ENV = nEnv
      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const actualOutput0 = opts.bus.outQueueData[0].payload
      const actualOutput1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(actualOutput0.email, 'icentris.qa6+john.wick@gmail.com')
      assert.deepEqual(actualOutput1.email, 'icentris.qa6+abe@gmail.com')
      assert.deepEqual(actualOutput0.home_phone, '1111111111')
      assert.deepEqual(actualOutput1.mobile_phone, '1111111111')
    })
  })
}
