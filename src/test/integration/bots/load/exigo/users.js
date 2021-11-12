'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/user')
  })

  describe('#handle', function () {
    it('should load exigo cdc changes using domainobject into queue', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            Customers: [
              {
                CustomerID: 1
              }
            ]
          }
        }
      }]

      const expectedOut0 = {
        icentris_client: 'idlife',
        client_user_id: 1,
        first_name: 'Anakin',
        last_name: 'Skywalker',
        email: 'askywalker@icentris.com',
        home_phone: '385-549-9496',
        mobile_phone: '888-555-1212',
        fax_phone: '888-555-1212',
        address: '12346 Orion Ct East',
        address2: '',
        city: 'Willis',
        state: 'TX',
        postal_code: '77318',
        county: '',
        country: 'US',
        mail_address: '12876 Orion Ct East',
        mail_address2: '',
        mail_city: 'Willis',
        mail_state: 'TX',
        mail_postal_code: '77318',
        mail_county: '',
        mail_country: 'US',
        signup_date: '2012-03-27T00:00:00.000Z',
        birth_date: '1957-04-26T00:00:00.000Z',
        company_name: '',
        rank: {
          client_level: 2,
          name: 'Independent Associate'
        },
        status: {
          id: 1,
          description: 'Active'
        },
        type: {
          id: 5,
          description: 'Independent Associate'
        },
        upline: {
          client_sponsor_id: 813500,
          client_parent_id: 813500
        },
        is_downline_contact: false,
        extra: {
          web_alias: 'dv'
        }
      }
      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 1)
      const out0 = opts.bus.outQueueData[0].payload
      expectedOut0.signup_date = new Date(expectedOut0.signup_date)
      expectedOut0.birth_date = new Date(expectedOut0.birth_date)
      assert.deepEqual(out0, expectedOut0)
    })
  })
}
