'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleMappings = {
    in0: {
      order_id: '1234',
      icentris_client: 'bluesun',
      client_user_id: 'd5678',
      order_date: '2018-01-01 09:30:00',
      tracking_numbers: [
        'z12345'],
      total: '120.00',
      personal_volume: '60',
      commission_volume: '50',
      autoship_template: {
        id: 12344
      },
      items: [{
        sku: 'p1243z5',
        name: 'Widget 1',
        description: 'Does 1 thing well'
      }, {
        sku: 'p1235z6',
        name: 'Widget 2',
        description: 'Does 2 things'
      }],
      extra: {
        dealer_id: '1234',
        dealership_id: '5678'
      },
      status: {
        id: 1,
        description: 'Active'
      }
    },
    in1: {
      order_id: '1235',
      icentris_client: 'bluesun',
      client_user_id: 'd5679',
      order_date: '2018-01-01 10:30:00',
      tracking_numbers: [
        'z10345'],
      total: '110.00',
      personal_volume: '65',
      commission_volume: '40',
      autoship_template: {
        id: 12345
      },
      items: [{
        sku: 'p1243z6',
        name: 'Whatzit 1',
        description: "She's a beaut"
      }, {
        sku: 'p1235z7',
        name: 'Bran 2',
        description: 'Indespensible'
      }],
      extra: {
        dealer_id: '1034',
        dealership_id: '5679'
      },
      status: {
        id: 9,
        description: 'Cancelled'
      }
    },
    out0: {
      order_id: '1234',
      icentris_client: 'bluesun',
      client_user_id: 'd5678',
      order_date: '2018-01-01 14:30:00',
      tracking_numbers: [
        'z12345'],
      total: '120.00',
      personal_volume: '60',
      commission_volume: '50',
      autoship_template: {
        id: 12344
      },
      items: [{
        sku: 'p1243z5',
        name: 'Widget 1',
        description: 'Does 1 thing well'
      }, {
        sku: 'p1235z6',
        name: 'Widget 2',
        description: 'Does 2 things'
      }],
      extra: {
        dealer_id: '1234',
        dealership_id: '5678'
      },
      status: {
        id: 1,
        description: 'Active'
      }
    },
    out1: {
      order_id: '1235',
      icentris_client: 'bluesun',
      client_user_id: 'd5679',
      order_date: '2018-01-01 15:30:00',
      tracking_numbers: [
        'z10345'],
      total: '110.00',
      personal_volume: '65',
      commission_volume: '40',
      autoship_template: {
        id: 12345
      },
      items: [{
        sku: 'p1243z6',
        name: 'Whatzit 1',
        description: "She's a beaut"
      }, {
        sku: 'p1235z7',
        name: 'Bran 2',
        description: 'Indespensible'
      }],
      extra: {
        dealer_id: '1034',
        dealership_id: '5679'
      },
      status: {
        id: 9,
        description: 'Cancelled'
      }
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('plmb/utc_transform/order')
  })

  // handle functionality was moved to the superclass TrinityLoader, but this
  // tests some actual data so it remains.
  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        sampleMappings.in0,
        sampleMappings.in1
      ]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(out0, sampleMappings.out0)
      assert.deepEqual(out1, sampleMappings.out1)
    })
  })
}
