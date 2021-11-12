'use strict'

const Mapper = require('../../../../../bots/map/mapper')
const _ = require('lodash')

// offload maps - mee 7/28/18
const treeUserMap = require('../../../../../bots/offload/vibe/users/tree_users.json')
const pyrContactsMap = require('../../../../../bots/offload/vibe/users/pyr_contacts.json')

module.exports = (opts) => {
  const assert = opts.assert
  let mapper
  before(() => {
    mapper = new Mapper(opts.mysql)
  })

  let bot
  beforeEach(() => {
    bot = opts.getBot('offload/vibe/users')
  })

  describe('#handle', async function () {
    beforeEach(async () => {
      await Promise.all(
        bot.affectedTables().map(table => opts.mysql.truncate(table))
      )

      await Promise.all([
        opts.mysql.truncate('tree_users'),
        opts.mysql.truncate('pyr_contacts'),
        opts.mysql.truncate('users')
      ])

      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        tree_user_id: '',
        user_id: '1',
        rank_id: '1',
        type_id: '1',
        user_status_id: '1',
        client_user_id: '1234',
        parent_id: null,
        sponsor_id: null,
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
          parent_id: '',
          sponsor_id: '',
          client_parent_id: '2345',
          client_sponsor_id: '4566'
        },
        extra: {
          _comment: 'Client specific addon fields',
          dealer_id: '12345-should-go-to-field1',
          contact_category_id: '987'
        }
      }, {
        icentris_client: 'bluesun',
        tree_user_id: '',
        user_id: '2',
        rank_id: '2',
        type_id: '2',
        user_status_id: '2',
        parent_id: 1,
        sponsor_id: 1,
        contact_id: 2,
        client_user_id: '1235',
        first_name: 'Jane',
        last_name: 'Ware',
        email: 'warewulf@assassinsr.us',
        home_phone: '5556789433',
        mobile_phone: '5551230988',
        address: '124 Unsafe Street',
        address2: 'Ste 501',
        city: 'Metropolis',
        state: 'Kansas',
        postal_code: '84301',
        county: 'Nowhere',
        country: 'USA',
        signup_date: '2003-03-02 10:00:00',
        birth_date: '1964-05-04',
        updated_at: '2019-01-10 07:41:24',
        company_name: 'Assassins R US',
        rank: {
          id: '2',
          description: 'Silver Leader'
        },
        type: {
          id: '2',
          description: 'Super Distributor'
        },
        status: {
          id: '2',
          description: 'Purgatory'
        },
        plus: {
          _comment: 'Can include any other fields/values not documented in the generic object structure'
        },
        info: 'Client specific addon fields',
        upline: {
          parent_id: '',
          sponsor_id: '',
          client_parent_id: '2346',
          client_sponsor_id: '4567'
        },
        extra: {
          _comment: 'Client specific addon fields',
          dealer_id: '1235',
          contact_category_id: '765'
        }
      }] // inQueueData

      await Promise.all(opts.bus.inQueueData.map(async user => {
        user.tree_user_id = await mapper.treeUserId(user.client_user_id)

        if (user.upline && user.upline.client_sponsor_id) {
          user.contact_user_id = await mapper.userId(user.upline.client_sponsor_id)
        }
      }))
    }) // end beforeEach

    it('writes the tree_users records', async function () {
      await bot.handle(opts.event, opts.context)

      const treeUsers = await opts.mysql.execute('SELECT * FROM tree_users').then(rs => rs[0])

      assert.equal(treeUsers.length, 2)

      const mappedKeys = Object.keys(treeUserMap.default)
      assert(mappedKeys.length > 0)

      return opts.bus.Promise.map(opts.bus.inQueueData, async mappedUser => {
        mappedKeys.forEach(oldKey => {
          const treeUser = _.find(treeUsers, o => {
            return o.id === mappedUser.tree_user_id
          })

          const newKey = treeUserMap.default[oldKey]
          let valueIn = _.get(mappedUser, oldKey)
          let valueOut = treeUser[newKey]

          if (_.includes(['birth_date', 'created_date', 'signup_date'], newKey)) {
            valueIn = new Date(valueIn).getTime()
            valueOut = new Date(valueOut).getTime()
          }

          // console.debug(`${oldKey}:${valueIn}; ${newKey}:${valueOut}`)
          assert.equal(valueIn, valueOut, `newKey ${newKey} !== oldKey ${oldKey}`)
        })
      })
    }) // end tree_users output test - mee 7/24/18

    it('writes the pyr_contacts records', async function () {
      this.timeout(21000)

      await bot.handle(opts.event, opts.context)

      return Promise.all(opts.bus.inQueueData.map(async mappedUser => {
        const offloadQuery = 'SELECT * FROM pyr_contacts WHERE pyr_contacts.tree_user_id in (1,2)'
        const offloadedData = await opts.mysql.execute(offloadQuery)
        const pyrContactsRows = offloadedData[0] // written to db - mee 7-28-18

        assert.equal(pyrContactsRows.length, 2)

        const mappedUsers = opts.bus.inQueueData // inbound (from mapper) (simulated) - mee 7-28-18
        const mappedKeys = Object.keys(pyrContactsMap.default)

        // ensure we're testing the right mapping, that something is there - mee 7/24/18
        assert(mappedKeys.length > 0)

        mappedUsers.forEach((mapped, index) => {
          // test each individual mapping. no need to duplicate by copying code here...
          // it will be brittle and one or the other could still be wrong. you just
          // have to make sure you have all the keys in there. - mee 7/28/18

          mappedKeys.forEach(oldKey => {
            const newKey = pyrContactsMap.default[oldKey]
            let valueIn = _.get(mapped, oldKey)
            let valueOut = pyrContactsRows[index][newKey]

            if (_.includes(['birthday', 'updated_at'], newKey)) {
              valueIn = new Date(valueIn).getTime()
              valueOut = new Date(valueOut).getTime()
            }

            // console.debug(`${oldKey}:${valueIn}; ${newKey}:${valueOut}`)
            assert.equal(valueIn, valueOut, `newKey ${newKey} !== oldKey ${oldKey} for object ${index}`)
          })
        })
      }))
    }) // end offload to pyr_contacts test - mee 7/27/18

    it('writes the pyr_contact_emails records', async function () {
      await bot.handle(opts.event, opts.context)

      return Promise.all(opts.bus.inQueueData.map(async mappedUser => {
        const contactIdQ = 'SELECT ID FROM pyr_contacts WHERE pyr_contacts.tree_user_id IN (1,2)'
        let contactIds = await opts.mysql.execute(contactIdQ)
        contactIds = contactIds[0].map(result => result.ID)

        const offloadQuery = `SELECT * FROM pyr_contact_emails WHERE pyr_contact_emails.contact_id in (${contactIds})`
        const offloadedData = await opts.mysql.execute(offloadQuery)

        const pyrContactEmailsRows = offloadedData[0] // written to db - mee 7-28-18
        assert.equal(pyrContactEmailsRows.length, 2)

        const mappedUsers = opts.bus.inQueueData // inbound (from mapper) (simulated) - mee 7-28-18

        for (let i = 0; i < pyrContactEmailsRows.length; i++) {
          assert.equal(mappedUsers[i].email, pyrContactEmailsRows[i].email) // pyrContactEmailsRows[i]["email"])
        }
      }))
    }) // end pyr_contact_emails test - mee 8/2/18

    it.skip('writes the pyr_contacts_contact_categories records', async function () {
      await bot.handle(opts.event, opts.context)

      return Promise.all(opts.bus.inQueueData.map(async mappedUser => {
        const contactIdQ = 'SELECT ID FROM pyr_contacts WHERE pyr_contacts.tree_user_id IN (1,2)'
        let contactIds = await opts.mysql.execute(contactIdQ)
        contactIds = contactIds[0].map(result => result.ID)

        const offloadQuery = `SELECT * FROM pyr_contacts_contact_categories WHERE pyr_contacts_contact_categories.contact_id in (${contactIds})`
        const offloadedData = await opts.mysql.execute(offloadQuery)

        const pyrContactCategoryRows = offloadedData[0]
        assert.equal(pyrContactCategoryRows.length, 2)

        const mappedUsers = opts.bus.inQueueData
        for (let i = 0; i < pyrContactCategoryRows.length; i++) {
          assert.equal(mappedUsers[i].extra.contact_category_id, pyrContactCategoryRows[i].contact_category_id)
        }
      }))
    })

    /** @author: Matt Ewell
     * @summary: Test dump to pyr_contact_phone_numbers table
     * @since: 8/4/2018
     * @description: Schema is below. We're using unformatted phone number and
     *   label
     * create_table "pyr_contact_phone_numbers", force: :cascade do |t|
     *   t.integer "contact_id",               limit: 4
     *   t.string  "phone_number",             limit: 255
     *   t.string  "label",                    limit: 255
     *   t.string  "unformatted_phone_number", limit: 255
     *   t.string  "source",                   limit: 255
     *   t.string  "dialing_code",             limit: 255
     * end
     **/
    it('writes the pyr_contact_phone_numbers records', async function () {
      await bot.handle(opts.event, opts.context)

      return Promise.all(opts.bus.inQueueData.map(async mappedUser => {
        const contactIdQ = 'SELECT ID FROM pyr_contacts WHERE pyr_contacts.tree_user_id IN (1,2)'
        let contactIds = await opts.mysql.execute(contactIdQ)
        contactIds = contactIds[0].map(result => result.ID)

        const offloadQuery = `SELECT * FROM pyr_contact_phone_numbers WHERE pyr_contact_phone_numbers.contact_id in (${contactIds})`
        const offloadedData = await opts.mysql.execute(offloadQuery)

        const phoneNumberRows = offloadedData[0]
        assert.equal(phoneNumberRows.length, 4)

        const mappedUsers = opts.bus.inQueueData // inbound (from mapper) (simulated) - mee 7-28-18

        // cms_dropdown :label, [:cell, :home, :work, :other]

        // ensure pyr_contact_phone_numbers entry made for mappedUsers.phone_number
        const homePhoneRows = _.filter(phoneNumberRows, row => {
          return row.label === 'home'
        })

        assert.equal(homePhoneRows.length, 2)

        homePhoneRows.forEach(row => {
          // find the inbound user - mee 8/4/2018
          const user = _.find(mappedUsers, user => {
            return user.contact_id === row.contact_id
          })

          // ensure the inbound user's home phone matches what was stored - mee 8/4/2018
          assert.equal(row.unformatted_phone_number, user.home_phone)
        })

        const mobilePhoneRows = _.filter(phoneNumberRows, row => {
          return row.label === 'cell'
        })

        mobilePhoneRows.forEach(row => {
          // find the inbound user - mee 8/4/2018
          const user = _.find(mappedUsers, user => {
            return user.contact_id === row.contact_id
          })

          // ensure the inbound user's home phone matches what was stored - mee 8/4/2018
          assert.equal(row.unformatted_phone_number, user.mobile_phone)
        })
      }))
    }) // end pyr_contact_phone_numbers test - mee 8/2/18

    it('writes to pyr_contact_sources', async function () {
      await bot.handle(opts.event, opts.context)
      const contactIdQ = 'SELECT ID FROM pyr_contacts WHERE pyr_contacts.tree_user_id IN (1,2)'
      let contactIds = await opts.mysql.execute(contactIdQ)
      contactIds = contactIds[0].map(result => result.ID)

      const contactSourcesQ = `SELECT * FROM pyr_contact_sources WHERE pyr_contact_sources.contact_id IN (${contactIds})`
      const contactSources = await opts.mysql.execute(contactSourcesQ)
      const contactSourcesRows = contactSources[0]

      assert.equal(contactSourcesRows.length, 2)

      contactSourcesRows.forEach(row => {
        assert.equal(row.system_type, 'databus')
      })
    })

    it('places contact "extra" fields that are not mapped into the "json_custom_data" field', () => {
      const table = 'pyr_contacts'
      const payload = {
        icentris_client: 'avon', // <-- This is Avon specific
        updated_at: '2019-01-15 13:12:11',
        _comment: 'test',
        extra: {
          luke: 'skywalker',
          darth: 'sidious'
        }
      }

      const expected = { custom_json_data: JSON.stringify({ luke: 'skywalker', darth: 'sidious' }) }
      assert.deepEqual(expected, bot.applyTransforms(payload, table))
    })

    it('updates an existing contact record', async function () {
      this.timeout(5000)

      await opts.mysql.truncate('pyr_contacts')
      opts.mysql.execute(`INSERT INTO pyr_contacts(tree_user_id, first_name, last_name) VALUES('${opts.bus.inQueueData[0].tree_user_id}', '${opts.bus.inQueueData[0].first_name}-updated', '${opts.bus.inQueueData[0].last_name}')`)

      const beforeRs = await opts.mysql.execute(`SELECT id, first_name, last_name FROM pyr_contacts WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      if (beforeRs) {
        assert.equal(beforeRs.id, 1)
        assert.equal(beforeRs.first_name, `${opts.bus.inQueueData[0].first_name}-updated`)
      }

      await bot.handle(opts.event, opts.context)

      const afterRs = await opts.mysql.execute(`SELECT id, first_name, last_name FROM pyr_contacts WHERE tree_user_id = '${opts.bus.inQueueData[0].tree_user_id}'`).then(rs => rs[0][0])
      assert.equal(afterRs.id, 1)
      assert.equal(afterRs.first_name, opts.bus.inQueueData[0].first_name)
      assert.equal(afterRs.last_name, opts.bus.inQueueData[0].last_name)
    })

    it('pyrContactsOffloadTransforms only injects updated_at when not present in the payload', () => {
      const table = 'pyr_contacts'
      const payload = {
        icentris_client: 'bluesun'
      }

      // Should inject it
      const shouldResult = bot.applyTransforms(payload, table)
      assert.equal(_.has(shouldResult, 'updated_at'), true)

      // Should not inject it
      Object.assign(payload, { updated_at: '2019-01-15 13:12:11' })
      const shouldNotResult = bot.applyTransforms(payload, table)
      assert.equal(_.has(shouldNotResult, 'updated_at'), false)
    })

    it('should update an existing tree_user user_status_id', async () => {
      try {
        await bot.handle(opts.event, opts.context)

        /** Sample payload from Trinity -- ndg 5/31/2019
         * {
        "tree_user_id": 986,
        "user_status_id": 7,
        "contact_id": 664,
        "tree_user_plus_id": 986,
        "client_user_id": "d788124",
        "extra": {
            "dealership_id": "788124"
        },
        "status": {
            "id": "7",
            "description": "Dealership Terminated"
        },
        "icentris_client": "nevetica"
      } **/

        opts.bus.inQueueData = opts.bus.inQueueData.map(o => {
          return {
            tree_user_id: o.tree_user_id,
            contact_id: o.contact_id,
            tree_user_plus_id: o.tree_user_id,
            user_status_id: 7,
            status: { id: 7, description: 'Terminated' },
            icentris_client: o.icentris_client
          }
        })

        await bot.handle(opts.event, opts.context)

        const rs = await opts.mysql.execute('SELECT id, client_user_id, user_status_id  FROM tree_users')
          .then(([rs, _]) => {
            return rs
          })

        rs.forEach(o => {
          assert.strictEqual(o.user_status_id, 7)
        })
      } catch (err) {
        assert.fail(err)
      }
    })
  })
}
