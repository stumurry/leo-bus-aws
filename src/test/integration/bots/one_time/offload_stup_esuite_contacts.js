'use strict'
const crypto = require('crypto')

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(() => {
    bot = opts.getBot('one_time/offload_stup_esuite_contacts')
  })

  describe('#offload one time esuite file payload to Vibe', async function () {
    this.timeout(5000)
    beforeEach(async () => {
      await Promise.all([
        opts.mysql.truncate('pyr_contacts'),
        opts.mysql.truncate('pyr_notes'),
        opts.mysql.truncate('users'),
        opts.mysql.truncate('pyr_contact_emails'),
        opts.mysql.truncate('pyr_contact_phone_numbers')
      ])
    })

    it('should offload transformed contacts', async () => {
      const rawData = [
        ['4000547|#|Sally|#|👠Stamper|#|09 817 1361|#||#|stamper@stamper.com|#|41 Huia Rd|#||#|Auckland|#|Titirangi|#||#|4555|#|NZ|#|N|#|N|#|N|#|1|#|N|#|N|#||#|1989|#|12|#|8|#|2009|#|11|#|1|#|customerManager|#|16248'],
        ['45454464|#|Sally|#|Stamper|#|09 817 1361|#||#|stamper@stamper.com|#|41 Huia Rd|#||#|Auckland|#|Titirangi|#||#|4555|#|NZ|#|N|#|N|#|N|#|1|#|N|#|N|#||#|1989|#|12|#|8|#|2009|#|11|#|1|#|customerManager|#|162489'],
        ['4000547|#|a|#|a|#||#||#|icentris.qa15@gmail.com|#||#||#||#||#||#||#||#||#||#||#||#||#||#||#|0|#|0|#|0|#|0|#|0|#|0|#|showGuest|#|']
      ] // inQueueData
      const keys = ['consultant_id', 'first_name', 'last_name',
        'phone_number1', 'phone_number2', 'email_address',
        'mailing_address1', 'mailing_address2', 'city',
        'mailing_address_suburb', 'state', 'zip_code', 'country',
        'interest_host_workshop', 'interest_demonstrator', 'interest_mailing_list',
        'interest_catalog', 'interest_newsletter', 'interest_question', 'customer_notes',
        'birthday_year', 'birthday_month', 'birthday_day', 'last_contact_year',
        'last_contact_month', 'last_contact_day', 'contact_source',
        'customer_person_id_esuite'
      ]
      const dataForPersonIDs = []
      rawData.forEach(u => {
        const transform = u[0].split('|#|')
        const record = {}
        for (let i = 0; i < keys.length; i++) {
          let data = transform[i] !== undefined ? transform[i] : null

          if (typeof data === 'string') {
            const emojisQuote = /(\u00a9|'|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])/g
            data = data.replace(emojisQuote, '')
          }
          record[keys[i]] = data
        }
        dataForPersonIDs.push(Object.values(record).join(''))
      })
      for (let i = 0; i < dataForPersonIDs.length; i++) {
        dataForPersonIDs[i] = crypto.createHash('md5').update(dataForPersonIDs[i]).digest('hex').slice(0, 16)
      }

      opts.bus.inQueueData = [
        {
          icentris_client: 'bluesun',
          consultant_id: '4000547',
          first_name: 'Sally',
          last_name: 'Stamper',
          source: 7,
          phone_number: '09-817-1361',
          phone_number1: '09 817 1361',
          phone_number2: '',
          email_address: 'stamper@stamper.com',
          mailing_address1: '41 Huia Rd',
          mailing_address2: '',
          city: 'Auckland',
          mailing_address_suburb: 'Titirangi',
          state: '',
          zip_code: '4555',
          country: 'NZ',
          interest_host_workshop: 'N',
          interest_demonstrator: 'N',
          interest_mailing_list: 'N',
          interest_catalog: '1',
          interest_newsletter: 'N',
          interest_question: 'N',
          customer_notes: '',
          birthday_year: '1989',
          birthday_month: '12',
          birthday_day: '8',
          last_contact_year: '2009',
          last_contact_month: '11',
          last_contact_day: '1',
          contact_source: 'customerManager',
          customer_person_id_esuite: dataForPersonIDs[0],
          level_of_interest: 102,
          birthday: '1989-12-8',
          last_contacted: '2009-11-1',
          updated_at: '2019-06-26 15:16:48',
          notable_type: 'PyrCrm::Contact',
          home_label: 'home',
          mobile_label: 'cell',
          user_id: 3,
          created_by: 3
        }
      ] // inQueueData
      await opts.mysql.execute('INSERT INTO users (consultant_id) VALUES (4000547)')
      await bot.handle(opts.event, opts.context)
      let r = await opts.mysql.execute('SELECT * FROM pyr_contacts')
      // testing for no dupes
      //  assert.strictEqual(r[0].length, 1)
      assert.ok(r[0][0].last_contacted)
      assert.ok(r[0][0].birthday)
      assert.ok(r[0][0].customer_person_id_esuite)
      assert.strictEqual(r[0][0].level_of_interest, 102)
      assert.strictEqual(r[0][0].source, 7)
      assert.ok(r[0][0].updated_at)
      assert.strictEqual(r[0][0].address1, '41 Huia Rd')
      assert.strictEqual(r[0][0].city, 'Auckland')
      assert.strictEqual(r[0][0].suburb, 'Titirangi')
      assert.strictEqual(r[0][0].postal_code, '4555')
      assert.strictEqual(r[0][0].country, 'NZ')
      r = await opts.mysql.execute('SELECT * FROM pyr_contact_emails')
      assert.strictEqual(r[0][0].email, 'stamper@stamper.com')
      r = await opts.mysql.execute('SELECT * FROM pyr_notes')
      assert.strictEqual(r[0][0].notable_type, 'PyrCrm::Contact')
      r = await opts.mysql.execute('SELECT * FROM pyr_contact_phone_numbers')
      assert.strictEqual(r[0][0].unformatted_phone_number, '09 817 1361')
    })

    it.skip('should efficiently lookup in mysql using user_id and customer_person_id_esuite', async () => {
      const rawRow = ['4000547|#|a|#|a|#||#||#|icentris.qa15@gmail.com|#||#||#||#||#||#||#||#||#||#||#||#||#||#||#|0|#|0|#|0|#|0|#|0|#|0|#|showGuest|#|']
      const personId = crypto.createHash('md5').update(rawRow.join('')).digest('hex').slice(0, 16)
      await opts.mysql.execute('INSERT INTO users (consultant_id) VALUES (4000547)')
      await opts.mysql.execute('INSERT INTO pyr_contacts (customer_person_id_esuite) VALUES (16248)')
      await opts.mysql.execute(`
        INSERT INTO pyr_contacts (customer_person_id_esuite) VALUES ('${personId}')
      `)

      const in0 = {
        icentris_client: 'bluesun',
        consultant_id: '4000547',
        first_name: 'Sally',
        last_name: 'Stamper',
        source: 7,
        phone_number: '09-817-1361',
        phone_number1: '09 817 1361',
        phone_number2: '',
        email_address: 'stamper@stamper.com',
        mailing_address1: '41 Huia Rd',
        mailing_address2: '',
        city: 'Auckland',
        mailing_address_suburb: 'Titirangi',
        state: '',
        zip_code: '4555',
        country: 'NZ',
        interest_host_workshop: 'N',
        interest_demonstrator: 'N',
        interest_mailing_list: 'N',
        interest_catalog: '1',
        interest_newsletter: 'N',
        interest_question: 'N',
        customer_notes: '',
        birthday_year: '1989',
        birthday_month: '12',
        birthday_day: '8',
        last_contact_year: '2009',
        last_contact_month: '11',
        last_contact_day: '1',
        contact_source: 'customerManager',
        customer_person_id_esuite: '16248',
        level_of_interest: 102,
        birthday: '1989-12-8',
        last_contacted: '2009-11-1',
        updated_at: '2019-06-26 15:16:48',
        notable_type: 'PyrCrm::Contact',
        home_label: 'home',
        mobile_label: 'cell',
        user_id: 3,
        created_by: 3
      }
      const in1 = {
        icentris_client: 'bluesun',
        consultant_id: '4000547',
        first_name: 'a',
        last_name: 'a',
        source: 1,
        phone_number: '',
        phone_number1: '',
        phone_number2: '',
        email_address: 'icentris.qa15@gmail.com',
        mailing_address1: '',
        mailing_address2: '',
        city: '',
        mailing_address_suburb: '',
        state: '',
        zip_code: '',
        country: '',
        interest_host_workshop: '',
        interest_demonstrator: '',
        interest_mailing_list: '',
        interest_catalog: '',
        interest_newsletter: '',
        interest_question: '',
        customer_notes: '',
        birthday_year: '0',
        birthday_month: '0',
        birthday_day: '0',
        last_contact_day: '0',
        last_contact_year: '0',
        last_contact_month: '0',
        contact_source: 'showGuest',
        customer_person_id_esuite: personId,
        level_of_interest: null,
        updated_at: '',
        notable_type: 'PyrCrm::Contact',
        home_label: 'home',
        mobile_label: 'cell',
        user_id: 1,
        created_by: 1
      }
      opts.bus.inQueueData = [in0, in1] // inQueueData

      opts.event = {
        icentris_client: 'bluesun',
        source: 'stup-transformed-esuite-contacts'
      }

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.equal(out0.message, 'contact already in the table')
      assert.equal(out1.message, 'contact already in the table')
    })
  })
}
