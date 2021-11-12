'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInput = [
    {
      _event: 'ORDER_VOIDED',
      icentris_client: 'bluesun',
      order_id: '1234',
      dealer_id: '123',
      dealership_id: '2345',
      voided_date: '2018-01-01 23:59:59'
    },
    {
      _event: 'ORDER_VOIDED',
      icentris_client: 'bluesun',
      order_id: '1235',
      dealer_id: '124',
      dealership_id: '2346',
      voided_date: '2018-01-02 00:00:01',
      status: {
        id: 9,
        description: 'Cancelled'
      }
    }]

  const expectedOutput = [
    {
      icentris_client: 'bluesun',
      order_id: '1234',
      client_user_id: 'd2345',
      status: {
        id: 9,
        description: 'Cancelled'
      },
      voided_date: '2018-01-01 23:59:59',
      extra: {
        dealer_id: '123',
        dealership_id: '2345'
      }
    },
    {
      icentris_client: 'bluesun',
      order_id: '1235',
      client_user_id: 'd2346',
      voided_date: '2018-01-02 00:00:01',
      status: {
        id: 9,
        description: 'Cancelled'
      },
      extra: {
        dealer_id: '124',
        dealership_id: '2346'
      }
    }]

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/order_voided')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = sampleInput
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 2)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.deepEqual(out0, expectedOutput[0])
      assert.deepEqual(out1, expectedOutput[1])
    })
  })
}
