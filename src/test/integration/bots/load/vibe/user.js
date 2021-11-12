'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'tree_users'
    await opts.mysql.truncate(opts.event.table)

    const treeUsers = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([{
        id: 1,
        sponsor_id: null,
        parent_id: null,
        first_name: 'Obi-Wan',
        last_name: 'Kenobi',
        company_name: 'The Rebellion',
        address1: null,
        address2: null,
        city: null,
        state: null,
        zip: '11111',
        country: null,
        email: null,
        phone: null,
        mobile_phone: '1-800-444-HOPE',
        gender: 'M',
        birth_date: null,
        date1: '2018-12-25 23:58:00',
        updated_date: '2020-01-13 23:58:00',
        user_type_id: 1,
        user_status_id: 1
      }, {
        id: 2,
        sponsor_id: 1,
        parent_id: 1,
        first_name: 'John',
        last_name: 'Doe',
        company_name: 'Acme Co.',
        address1: '12345 Main St',
        address2: null,
        city: 'Whoville',
        state: 'Arkansas',
        zip: '22222',
        country: 'US',
        email: 'john@acme.foo',
        phone: null,
        mobile_phone: null,
        gender: 'M',
        birth_date: '1984-02-14',
        date1: '2018-12-25 23:58:00',
        updated_date: '2020-01-13 23:58:00',
        user_type_id: 1,
        user_status_id: 1
      }, {
        id: 3,
        sponsor_id: 2,
        parent_id: 2,
        first_name: 'Darth',
        last_name: 'Vader',
        company_name: 'The Empire',
        address1: null,
        address2: null,
        city: null,
        state: null,
        zip: '33333',
        country: 'US',
        email: 'dmoney@theempire.foo',
        phone: null,
        mobile_phone: null,
        gender: 'N',
        birth_date: null,
        date1: '2018-12-25 23:58:00',
        updated_date: '2020-01-13 23:58:00',
        user_type_id: 2,
        user_status_id: 1
      }, {
        id: 4,
        sponsor_id: 3,
        parent_id: 3,
        first_name: 'Jane',
        last_name: 'Doe',
        company_name: null,
        address1: '54321 1st Ave',
        address2: 'Ste 101',
        city: 'Anycity',
        state: 'MT',
        zip: '44444',
        country: 'US',
        email: 'jane@acme.foo',
        phone: null,
        mobile_phone: null,
        gender: 'F',
        birth_date: '1968-03-21',
        date1: '2018-12-25 23:58:00',
        updated_date: '2020-01-13 23:58:00',
        user_type_id: 1,
        user_status_id: 1
      }])
      .toString()

    await opts.mysql.execute(treeUsers)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          tree_users: [1, 2, 3, 4]
        }
      },
      delete: {
        'pyr-bluesun-local': {
          tree_users: [6]
        }
      }
    }]
  })

  describe('#handle', () => {
    it('should load the domain objects for ids 1, 2, 3, 4', async () => {
      await bot.handle(opts.event, opts.context)
      assert(opts.bus.outQueueData.length === 4)

      const ids = opts.bus.outQueueData.map(o => {
        const p = o.payload

        assert(Object.keys(p).length > 0)
        assert.strictEqual(p.icentris_client, 'bluesun')

        return o.domain_id
      })

      assert.deepEqual([1, 2, 3, 4], ids)
    })
  })
}
