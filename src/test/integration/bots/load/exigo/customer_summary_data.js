'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/customer_summary_data')
  })

  beforeEach(async () => {
    bot = opts.getBot('load/exigo/customer_summary_data')
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
              { CustomerID: 1 }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)
    })

    it('should map fields properly', async function () {
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

      const extra = {
        founding_member: '1',
        renewal_date: '',
        eligible_for_free_idn_product: '',
        icentris_customerid: '',
        wellness_careington_customer_price_type: '',
        waiting_room: '',
        recognition_names: '',
        ssn_ein_verified: '1',
        physician_designation: '',
        patient_details: '',
        referring_customer_id: ''
      }

      await bot.handle(opts.event, opts.context)
      assert.deepEqual(opts.bus.outQueueData[0].payload.extra, extra)
    })
  })
}
