'use strict'

const Mapper = require('../../../../../bots/map/mapper')
const customerTypes = require('../../../../../bots/offload/vibe/customer_types.json')

module.exports = (opts) => {
  const assert = opts.assert
  let mapper
  let types

  before(() => {
    mapper = new Mapper(opts.mysql)
    opts.event.blacklisted_clients = []
  })

  let bot
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/upline_tree_rebuild')
  })

  describe('#upline and tree rebuild', () => {
    beforeEach(async () => {
      // await opts.mysql.truncate('tree_users')
      await opts.mysql.execute('TRUNCATE TABLE tree_users')

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: '',
        user_id: '1',
        rank_id: '1',
        type_id: '1',
        user_status_id: '1',
        client_user_id: '1234',
        parent_id: 10,
        sponsor_id: 11,
        contact_id: 1,
        first_name: 'John',
        last_name: 'Wick',
        email: 'john.wick@assassinsr.us',
        home_phone: '5556789432',
        mobile_phone: '5551230987',
        address: '123 Easy Street',
        address2: 'Ste 500',
        city: 'Metropolis',
        state: 'Kansas',
        postal_code: '84302',
        county: 'Nowhere',
        country: 'USA',
        signup_date: '2003-03-01 10:00:00',
        birth_date: '1964-05-03',
        updated_at: '2019-01-10 07:41:23',
        company_name: 'Assassins R US',
        rank: {
          id: '1',
          description: 'Gold Leader'
        },
        type: {
          id: '1',
          description: 'Distributor'
        },
        status: {
          id: '1',
          description: 'Active'
        },
        plus: {
          _comment: 'Can include any other fields/values not documented in the generic object structure'
        },
        info: 'Client specific addon fields',
        upline: {
          client_parent_id: '2345',
          client_sponsor_id: '4566'
        },
        extra: {
          _comment: 'Client specific addon fields',
          dealer_id: '12345-should-go-to-field1',
          contact_category_id: '987'
        }
      }]

      await Promise.all(opts.bus.inQueueData.map(async user => {
        user.tree_user_id = await mapper.treeUserId(user.client_user_id)
      }))
    })

    describe('upline tests', () => {
      it('should insert upline when upline is null', async () => {
        await bot.handle(opts.event, opts.context)

        const offloadQuery = 'SELECT parent_id, sponsor_id FROM tree_users WHERE tree_users.id in (1)'
        const offloadedData = await opts.mysql.execute(offloadQuery)

        const treeUserUplineRows = offloadedData[0]

        assert.equal(treeUserUplineRows.length, 1)

        const out0 = treeUserUplineRows[0]

        assert.equal(out0.parent_id, opts.bus.inQueueData[0].parent_id)
        assert.equal(out0.sponsor_id, opts.bus.inQueueData[0].sponsor_id)
      })

      it('should update upline', async () => {
        await bot.handle(opts.event, opts.context)

        opts.bus.inQueueData[0].parent_id = '16'
        opts.bus.inQueueData[0].sponsor_id = '17'

        await bot.handle(opts.event, opts.context)

        const offloadQuery = 'SELECT parent_id, sponsor_id FROM tree_users WHERE tree_users.id in (1)'
        const offloadedData = await opts.mysql.execute(offloadQuery)

        const treeUserUplineRows = offloadedData[0]

        const out0 = treeUserUplineRows[0]

        assert.equal(treeUserUplineRows.length, 1)
        assert.equal(out0.parent_id, opts.bus.inQueueData[0].parent_id)
        assert.equal(out0.sponsor_id, opts.bus.inQueueData[0].sponsor_id)
      })

      it('should not update sponsor if not present in payload', async () => {
        delete opts.bus.inQueueData[0].sponsor_id
        delete opts.bus.inQueueData[0].upline.sponsor_id
        delete opts.bus.inQueueData[0].upline.client_sponsor_id

        // We will expect this value to be untouched by the bot
        const sponsorId = 100
        const clientSponsorId = 'c100'
        await opts.mysql.execute(`UPDATE tree_users SET sponsor_id = ${sponsorId}, client_sponsor_id = '${clientSponsorId}' WHERE tree_users.id = 1`)

        let verifyRS = await opts.mysql.execute('SELECT sponsor_id, client_sponsor_id FROM tree_users WHERE tree_users.id = 1').then(rs => rs[0][0])

        assert.equal(verifyRS.sponsor_id, sponsorId)
        assert.equal(verifyRS.client_sponsor_id, clientSponsorId)

        await bot.handle(opts.event, opts.context)

        verifyRS = await opts.mysql.execute('SELECT sponsor_id, client_sponsor_id FROM tree_users WHERE tree_users.id = 1').then(rs => rs[0][0])

        assert.equal(verifyRS.sponsor_id, sponsorId)
        assert.equal(verifyRS.client_sponsor_id, clientSponsorId)
      })

      it('should not update parent if not present in payload', async () => {
        delete opts.bus.inQueueData[0].parent_id
        delete opts.bus.inQueueData[0].upline.parent_id
        delete opts.bus.inQueueData[0].upline.client_parent_id

        // We will expect this value to be untouched by the bot
        const parentId = 100
        const clientParentId = 'c100'
        await opts.mysql.execute(`UPDATE tree_users SET parent_id = ${parentId}, client_parent_id = '${clientParentId}' WHERE tree_users.id = 1`)

        let verifyRS = await opts.mysql.execute('SELECT parent_id, client_parent_id FROM tree_users WHERE tree_users.id = 1').then(rs => rs[0][0])

        assert.equal(verifyRS.parent_id, parentId)
        assert.equal(verifyRS.client_parent_id, clientParentId)

        await bot.handle(opts.event, opts.context)

        verifyRS = await opts.mysql.execute('SELECT parent_id, client_parent_id FROM tree_users WHERE tree_users.id = 1').then(rs => rs[0][0])

        assert.equal(verifyRS.parent_id, parentId)
        assert.equal(verifyRS.client_parent_id, clientParentId)
      })
    })

    describe('dynamodbOffload', () => {
      beforeEach(() => {
        types = Object.assign(customerTypes.default, customerTypes[opts.bus.inQueueData[0].icentris_client])
      })

      it('should output correct sponsor tree rebuild payload for a customer', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.customer} WHERE tree_users.id in (1)`)
        await bot.handle(opts.event, opts.context)

        assert.equal(opts.bus.outQueueData.length, 1)
        const out = opts.bus.outQueueData[0]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Sponsor')
      })

      it('should output correct sponsor tree rebuild payload for a preferred_customer', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.preferred_customer} WHERE tree_users.id in (1)`)
        await bot.handle(opts.event, opts.context)

        assert.equal(opts.bus.outQueueData.length, 1)
        const out = opts.bus.outQueueData[0]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Sponsor')
      })

      it('should output correct placement tree rebuild payload for a distributor', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)
        // First time both tree rebuilds are trigger because at first parent and sponsor are null
        // Hence two payloads in output queue
        await bot.handle(opts.event, opts.context)
        opts.bus.inQueueData[0].parent_id = '16'

        // Second time is trigger there'll be a 3rd payload in the bus
        await bot.handle(opts.event, opts.context)
        const out = opts.bus.outQueueData[2]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Placement')
      })

      it('should output correct sponsor and placement tree rebuild payloads for a distributor', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)
        await bot.handle(opts.event, opts.context)

        const out = opts.bus.outQueueData[0]
        const out1 = opts.bus.outQueueData[1]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Sponsor')

        assert.ok(out1.created_time)
        assert.equal(out1.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out1.type, 'Placement')
      })

      it('should not trigger any tree rebuild', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)

        opts.bus.inQueueData[0].parent_id = undefined
        opts.bus.inQueueData[0].sponsor_id = undefined

        await bot.handle(opts.event, opts.context)
        assert.equal(opts.bus.outQueueData, 0)
      })

      it('should only trigger tree rebuild for sponsor', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)

        opts.bus.inQueueData[0].parent_id = undefined

        await bot.handle(opts.event, opts.context)
        assert.equal(opts.bus.outQueueData.length, 1)
        const out = opts.bus.outQueueData[0]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Sponsor')
      })

      it('should only trigger tree rebuild for parent', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)

        opts.bus.inQueueData[0].sponsor_id = undefined

        await bot.handle(opts.event, opts.context)
        assert.equal(opts.bus.outQueueData.length, 1)
        const out = opts.bus.outQueueData[0]

        assert.ok(out.created_time)
        assert.equal(out.icentris_client, opts.bus.inQueueData[0].icentris_client)
        assert.equal(out.type, 'Placement')
      })

      it('should not trigger tree rebuild for blacklisted clients', async () => {
        await opts.mysql.execute(`UPDATE tree_users SET user_type_id = ${types.distributor} WHERE tree_users.id in (1)`)
        opts.event.blacklisted_clients.push('bluesun')

        await bot.handle(opts.event, opts.context)
        assert.equal(opts.bus.outQueueData, 0)
      })
    })
  })
}
