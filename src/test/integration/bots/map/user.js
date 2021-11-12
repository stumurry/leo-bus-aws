'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(async () => {
    await opts.mysql.execute('TRUNCATE TABLE tree_users')
    await opts.mysql.execute('TRUNCATE TABLE tree_user_plus')
    await opts.mysql.execute('TRUNCATE TABLE tree_user_types')
    await opts.mysql.execute('TRUNCATE TABLE tree_user_statuses')
    await opts.mysql.execute('TRUNCATE TABLE  pyr_rank_definitions')
    await opts.mysql.execute('TRUNCATE TABLE  pyr_contacts')

    bot = opts.getBot('map/user')

    opts.bus.inQueueData = [{
      icentris_client: 'bluesun',
      client_user_id: 1,
      first_name: 'Garven',
      last_name: 'Dreis',
      email: 'garven.dreis@rebelalliance.org',
      rank: {
        client_level: 1,
        name: 'Squad Leader'
      },
      type: {
        id: 1,
        description: 'Rebel'
      },
      status: {
        id: 3,
        description: 'kia'
      },
      upline: {
        client_parent_id: 1234,
        client_sponsor_id: 12,
        sponsor_level: 4,
        sponsor_position: 0,
        parent_level: 3,
        parent_position: 1
      }
    }, {
      icentris_client: 'bluesun',
      client_user_id: 5,
      first_name: 'Darth',
      last_name: 'Vader',
      email: 'vader@evilempire.biz',
      rank: {
        client_level: 2,
        name: 'Lord'
      },
      type: {
        id: 2,
        description: 'Sith'
      },
      status: {
        id: 4,
        description: 'deceased'
      },
      upline: {
        client_parent_id: '1235',
        client_sponsor_id: '2468'
      }
    }, {
      icentris_client: 'bluesun',
      client_user_id: 6,
      first_name: 'Darth',
      last_name: 'Sidious',
      email: 'ds@evilempire.biz',
      rank: {
        client_level: 2,
        name: 'Lord'
      },
      type: {
        id: 2,
        description: 'Sith'
      },
      status: {
        id: 4,
        description: 'deceased'
      },
      upline: {
        client_parent_id: '1235',
        client_sponsor_id: '2468'
      }
    },
    {
      icentris_client: 'bluesun',
      client_user_id: 7,
      first_name: 'Dart',
      last_name: 'Sid',
      email: 'dart@evilempire.biz',
      paid_rank: {
        client_level: 4,
        name: 'Ring'
      },
      type: {
        id: 2,
        description: 'Sith'
      },
      status: {
        id: 1,
        description: 'Active'
      }
    }]
  })

  describe('#handle', async function () {
    it('should work', async function () {
      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 4)

      const user0 = opts.bus.outQueueData[0].payload
      const user1 = opts.bus.outQueueData[1].payload
      const user2 = opts.bus.outQueueData[2].payload
      const user3 = opts.bus.outQueueData[3].payload

      assert.strictEqual(user1.first_name, 'Darth')
      assert.strictEqual(user1.last_name, 'Vader')

      assert.ok(user0.rank_id)
      assert.ok(user1.rank_id)
      assert.ok(user2.rank_id)

      assert.strictEqual(user0.type_id, 1)
      assert.strictEqual(user1.type_id, 2)

      assert.strictEqual(user0.user_status_id, 3)
      assert.strictEqual(user1.user_status_id, 4)

      assert.ok(user0.parent_id)
      assert.ok(user0.sponsor_id)

      assert.ok(user1.parent_id)
      assert.ok(user1.sponsor_id)

      assert.strictEqual(user0.contact_id, 1)

      assert.deepEqual(user3.paid_rank, { client_level: 4, name: 'Ring' })
      // TODO Rewrite to be less brittle -- ndg 6/30/2017
      // brittle tests - relies on the order in which the async
      // calls are completed to create the tree_users records
      /* assert.strictEqual(user0.parent_id,2)
      assert.strictEqual(user1.parent_id,5)

      assert.strictEqual(user0.sponsor_id,3)
      assert.strictEqual(user1.sponsor_id,6) */
    })

    it.skip('only maps contact_user_id if is_downline_contact is falsy', async () => {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        client_user_id: 1,
        upline: {
          client_parent_id: 1234,
          client_sponsor_id: 12
        }
      }, {
        icentris_client: 'bluesun',
        client_user_id: 2,
        upline: {
          client_parent_id: 1235,
          client_sponsor_id: 13
        },
        is_downline_contact: false
      }, {
        icentris_client: 'bluesun',
        client_user_id: 3,
        upline: {
          client_parent_id: 1236,
          client_sponsor_id: 14
        },
        is_downline_contact: true
      }]

      await bot.handle(opts.event, opts.context)
      const user0 = opts.bus.outQueueData[0].payload
      const user1 = opts.bus.outQueueData[1].payload
      const user2 = opts.bus.outQueueData[2].payload
      assert.ok(user0.contact_user_id)
      assert.ok(user1.contact_user_id)
      assert.equal(user2.contact_user_id, null)
    })

    it('should insert a tree_user_plus stub record if one doesn\'t exist', async () => {
      this.timeout(5000)
      const rsBefore = await opts.mysql.execute('SELECT tree_user_id FROM tree_user_plus').then(rs => rs[0])
      assert.equal(0, rsBefore.length)

      await bot.handle(opts.event, opts.context)

      const user0 = opts.bus.outQueueData[0].payload
      assert.ok(user0.tree_user_plus_id)
    })

    it('should not insert a tree_user_plus stub record if one exists', async () => {
      this.timeout(5000)
      await opts.mysql.execute('INSERT INTO tree_user_plus(tree_user_id) VALUES(1)')
      await bot.handle(opts.event, opts.context)

      const treeUser1 = opts.bus.outQueueData.filter(d => d.payload.tree_user_id === 1)
      assert.equal(1, treeUser1.length)

      const rs = await opts.mysql.execute('SELECT tree_user_id FROM tree_user_plus WHERE tree_user_id = 1').then(rs => rs[0])
      assert.equal(1, rs.length)
    })
  })
}
