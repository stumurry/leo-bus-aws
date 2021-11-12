'use strict'

module.exports = (opts) => {
  let bot
  const assert = opts.assert

  before(async () => {
    bot = opts.getBot('load/vibe')

    opts.event.icentris_client = 'bluesun'
    opts.event.table = 'pyr_contacts'
    await opts.mysql.truncate(opts.event.table)

    const rows = opts.mysql.squel.insert({ autoQuoteTableNames: true, autoQuoteFieldNames: true })
      .into(opts.event.table)
      .setFieldsRows([{
        id: 1,
        first_name: 'Obi-Wan',
        last_name: 'Kenobi',
        contact_type: 1,
        source: null,
        level_of_interest: 1,
        address1: null,
        address2: null,
        city: null,
        state: null,
        postal_code: '11111',
        country: null,
        user_id: null,
        birthday: null,
        avatar_file_name: null,
        avatar_content_type: null,
        avatar_file_size: null,
        avatar_updated_at: null,
        info: null,
        is_downline_contact: null,
        downline_contact_lft: null,
        opt_in: null,
        tree_user_id: null,
        custom_json_data: null
      }, {
        id: 2,
        first_name: 'John',
        last_name: 'Doe',
        contact_type: 1,
        source: null,
        level_of_interest: 1,
        address1: '12345 Main St',
        address2: null,
        city: 'Whoville',
        state: 'Arkansas',
        postal_code: '22222',
        country: 'US',
        user_id: null,
        birthday: '1984-02-14',
        avatar_file_name: null,
        avatar_content_type: null,
        avatar_file_size: null,
        avatar_updated_at: null,
        info: null,
        is_downline_contact: null,
        downline_contact_lft: null,
        opt_in: null,
        tree_user_id: null,
        custom_json_data: null

      }, {
        id: 3,
        first_name: 'Darth',
        last_name: 'Vader',
        contact_type: 1,
        source: null,
        level_of_interest: 1,
        address1: null,
        address2: null,
        city: null,
        state: null,
        postal_code: '33333',
        country: 'US',
        user_id: null,
        birthday: null,
        avatar_file_name: null,
        avatar_content_type: null,
        avatar_file_size: null,
        avatar_updated_at: null,
        info: null,
        is_downline_contact: null,
        downline_contact_lft: null,
        opt_in: null,
        tree_user_id: null,
        custom_json_data: null

      }, {
        id: 4,
        first_name: 'Jane',
        last_name: 'Doe',
        contact_type: 1,
        source: null,
        level_of_interest: 1,
        address1: '54321 1st Ave',
        address2: 'Ste 101',
        city: 'Anycity',
        state: 'MT',
        postal_code: '44444',
        country: 'US',
        user_id: null,
        birthday: '1968-03-21',
        avatar_file_name: null,
        avatar_content_type: null,
        avatar_file_size: null,
        avatar_updated_at: null,
        info: null,
        is_downline_contact: null,
        downline_contact_lft: null,
        opt_in: null,
        tree_user_id: null,
        custom_json_data: null
      }])
      .toString()

    await opts.mysql.execute(rows)
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach(() => {
    opts.bus.inQueueData = [{
      update: {
        'pyr-bluesun-local': {
          pyr_contacts: [1, 2, 3, 4]
        }
      },
      delete: {
        'pyr-bluesun-local': {
          pyr_contacts: [6]
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
