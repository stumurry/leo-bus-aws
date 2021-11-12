'use strict'

const Mapper = require('../../../../../bots/map/mapper')

module.exports = (opts) => {
  const assert = opts.assert
  let mapper
  before(() => {
    mapper = new Mapper(opts.mysql)
  })

  let bot
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/commission')
  })

  describe('#handle', async function () {
    this.timeout(5000)

    beforeEach(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_commissions')
      await opts.mysql.execute('TRUNCATE TABLE tree_bonuses')
      opts.bus.inQueueData = [{
        commission_run_id: '100',
        tree_user_id: '1',
        commission_run_status_id: '2',
        period_id: '1',
        icentris_client: 'bluesun',
        client_user_id: '1234',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fee: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '1',
            description: 'Retail Bonus'
          },
          bonus_id: '1',
          amount: '230.00'
        }, {
          bonus: {
            id: '2',
            description: 'For being cool'
          },
          bonus_id: '2',
          amount: '35.00'
        }],
        commission_run: {
          id: '318',
          description: 'March 2018',
          run_date: '2018-03-30 09:00:00',
          accepted_date: '2018-03-31 09:00:00',
          status: {
            id: '2',
            description: 'Finished'
          },
          period: {
            client_period_id: '1234',
            period_type_id: '10',
            description: 'March 2018',
            start_date: '2018-03-01',
            end_date: '2018-03-31'
          }
        }
      }, {
        commission_run_id: '200',
        tree_user_id: '30',
        commission_run_status_id: '3',
        period_id: '2',
        icentris_client: 'bluesun',
        client_user_id: '3451',
        total: '500.00',
        earnings: '500.00',
        balance_forward: '0.00',
        previous_balance: '0.00',
        fee: '0.00',
        commission_bonuses: [{
          bonus: {
            id: '3',
            description: 'Retail Bonus'
          },
          bonus_id: '3',
          amount: '20.00'
        }, {
          bonus: {
            id: '4',
            description: 'For being cool'
          },
          bonus_id: '4',
          amount: '135.00'
        }],
        commission_run: {
          id: '418',
          description: 'April 2018',
          run_date: '2018-04-01 09:00:00',
          accepted_date: '2018-04-01 09:00:00',
          status: {
            id: '1',
            description: 'Started'
          },
          period: {
            client_period_id: '1235',
            period_type_id: '10',
            description: 'April 2018',
            start_date: '2018-04-01',
            end_date: '2018-04-30'
          }
        }
      }]

      await Promise.all(opts.bus.inQueueData.map(async (obj, k, arr) => {
        arr[k].client_user_id = await mapper.treeUserId(obj.client_user_id)
        if (obj.commission_bonuses) {
          arr[k].commission_bonuses[k].bonus.id = obj.commission_bonuses[k].bonus.id
        }
      }))

      await bot.handle(opts.event, opts.context)

      // leaving comment here  to assist with troubleshooting later
      // since errors are swallowed and piped to the outQueueData -- ndg 9/18/2018
      // console.log(opts.bus.outQueueData[0].payload)
      assert.equal(opts.bus.outQueueData.length, 0)
    })

    it('should write the tree_commissions records', async function () {
      await Promise.all(opts.bus.inQueueData.map(async (obj) => {
        let rs = await opts.mysql.execute('SELECT * FROM tree_commissions WHERE client_user_id = ?', [obj.client_user_id])
        rs = rs[0]
        assert.equal(rs.length, 1)
        assert.equal(parseInt(rs[0].client_user_id), parseInt(obj.client_user_id))
        assert.equal(parseInt(rs[0].earnings), parseInt(obj.earnings))
      }))
    })

    it('should write the tree_bonuses records', async function () {
      return Promise.all(opts.bus.inQueueData.map(async (obj) => {
        assert.equal(1, 1)
        let rs = await opts.mysql.execute('SELECT * FROM tree_commission_bonuses WHERE id = ?', [obj.commission_bonuses[0].bonus.id])
        rs = rs[0]
        assert.equal(rs.length, 1)
        rs = rs[0]
        assert.equal(parseInt(rs.id), parseInt(obj.commission_bonuses[0].bonus.id))
      }))
    })
  })
}
