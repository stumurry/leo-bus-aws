'use strict'

module.exports = (opts) => {
  // const assert = opts.assert

  before(async () => {
    await opts.mysql.truncate('users')
    await opts.mysql.truncate('tree_users')
    await opts.mysql.truncate('pyr_contacts')
  })

  it.skip('should take a CUSTOMER_ENROLLMENT event into the LoadTrinityCustomerEnrollmentBot and write to the client database in the users, tree_users, contacts tables', async function () {
    /* this.timeout(65000)

    let customerEnrollmentBot = opts.getBot('load/trinity/customer_enrollment')
    let mapUserBot = opts.getBot('map/user')
    let passthruUserBot = opts.getBot('passthru/user')
    let offloadVibeUsersBot = opts.getBot('offload/vibe/users')

    opts.bus.inQueueData = [{
      '_event': 'CUSTOMER_ENROLLMENT',
      icentris_client: 'bluesun',
      'dealer_id': '1234',
      'first_name': 'First',
      'last_name': 'Last',
      'company_name': 'Acme Co',
      'home_phone': '555-555-1234',
      'fax_phone': '555-123-5543',
      'mobile_phone': '555-555-4321',
      'email': 'test@example.com',
      'address1': '123 Easy Street',
      'address2': 'Ste 103',
      'city': 'Saratoga Springs',
      'state': 'UT',
      'postal_code': '84045',
      'county': 'Utah',
      'country': 'USA',
      'signup_date': '2018-01-01 23:59:58',
      'customer_type': {
        'id': '1', // **THIS WAS AN INTEGER IN ORIGINAL FEPS BUT
        // WE ARE ASSUMING IT WILL BE A STRING**
        'description': 'Retail Customer'
      },
      'birth_date': '1982-12-02',
      'sponsor': {
        'dealership_id': '1234',
        'dealer_id': '123'
      }
    }]

    const callback = (err, data) => {
      return new Promise((resolve, reject) => {
        if (err) reject(err)
        else resolve(data)
      })
    }

    const passInQueueData = () => {
      opts.bus.inQueueData = opts.bus.outQueueData.map(o => {
        return o.payload
      })

      opts.bus.outQueueData = []
    }

    try {
      await customerEnrollmentBot.handler(opts.event, opts.context, callback)

      passInQueueData()

      await mapUserBot.handler(opts.event, opts.context, callback)
      console.log(opts.bus.outQueueData)
//      passInQueueData()

 //     await passthruUserBot.handler(opts.event, opts.context, callback)

//      passInQueueData()

//      await offloadVibeUsersBot.handler(opts.event, opts.context, callback)

      /* const treeUsers = await opts.mysql.execute('SELECT * FROM tree_users').then(rs => {
        return rs[0]
      })

     console.log(treeUsers)
    } catch (err) {
      console.log('inside my catch statement!')
      assert.fail(err)
    }
    */
  })
}
