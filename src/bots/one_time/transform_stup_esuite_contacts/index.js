'use strict'

const Bot = require('../../bot')
const moment = require('moment')
const crypto = require('crypto')
const userIds = new Map()

class TransformStupEsuiteContacts extends Bot {
  async handle (event, context) {
    super.handle(event, context)
    const client = event.icentris_client
    const { source, destination } = event
    const botId = this.botId
    let notFound

    await this.getVibeDB(client).then(db => {
      const select = `
      SELECT
      u.consultant_id,
      u.id as user_id
      FROM users u
      `
      return db.query(select)
    })
      .then(rows => {
        // console.log('rows[0] ', rows[0])
        if (rows[0]) {
          rows[0].forEach(r => {
            userIds.set(r.consultant_id, r.user_id)
          })
        }
      })

    return this.transform(
      botId,
      source,
      destination,
      (payload, meta, done) => {
        const inObj = payload
        this.each(inObj, client)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              if (inObj && inObj.length > 0) notFound = inObj
              done(null)
            }
          })
          .catch(err => {
            console.log(err)
            done(err)
          })
      }
    ).then(() => {
      return this.closeAllVibeDBs()
    }).then(() => {
      if (notFound) return this.streamNoFoundRows(notFound)
    }).catch(async (err) => {
      await this.closeAllVibeDBs()
      throw err
    })
  }

  async streamNoFoundRows (payload) {
    const destination = 'stup-not-found-esuite-consultantids'
    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(destination))

    stream.on('error', err => {
      console.log('stream errored', err)
    })

    stream.write({
      payload
    })

    return new this.bus.Promise((resolve, reject) => {
      stream.end(err => {
        if (err) {
          reject(err)
        } else {
          resolve()
        }
      })
    })
  }

  // Processing time of a payload is less thant 0.03 seconds close to constant
  async each (payload, client) {
    if (!payload) return null
    const transform = payload[0].split('|#|')

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
    // map/process right columns. (Rake task logic from Brian)
    const record = {}
    for (let i = 0; i < keys.length; i++) {
      let data = transform[i] !== undefined ? transform[i] : null

      if (typeof data === 'string') {
        const emojisQuote = /(\u00a9|'|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])/g
        data = data.replace(emojisQuote, '')
      }
      record[keys[i]] = data
    }
    const dataForPersonID = Object.values(record).join('')
    // The following lines were translated from the rails rake task. From loi_mapping to record['last_contacted']
    // esuite has multiple levels of interest.  vibe only has 1
    const lois = ['interest_host_workshop', 'interest_demonstrator',
      'interest_mailing_list', 'interest_catalog',
      'interest_newsletter', 'interest_question'
    ]
    let loicount = 0
    let loimapping = null

    for (let i = 0; i < lois.length; i++) {
      if (String(record[lois[i]]) === '1' || String(record[lois[i]]) === 'Y') {
        loicount++
      }
    }

    const loipositives = (key) => {
      if (String(record[key]) === '1' || String(record[key]) === 'Y') {
        return true
      }
      return false
    }

    if (loicount > 1) {
      loimapping = 106 // all_of_above
    } else if (loicount === 1) {
      if (loipositives('interest_mailing_list')) {
        loimapping = 100 // 'mailing_list'
      }
      if (loipositives('interest_host_workshop')) {
        loimapping = 101 // 'host_a_Workshop' sic
      } else if (loipositives('interest_catalog')) {
        loimapping = 102 // 'request_a_catalog'
      } else if (loipositives('interest_demonstrator')) {
        loimapping = 103 // 'become_a_demonstator'
      } else if (loipositives('interest_newsletter')) {
        loimapping = 104 // 'request_my_newsletter'
      } else if (loipositives('interest_question')) {
        loimapping = 105 // 'general_question'
      }
    }

    record.level_of_interest = loimapping

    if (![0, NaN].includes(parseInt(record.birthday_year)) &&
     ![0, NaN].includes(parseInt(record.birthday_month)) &&
     ![0, NaN].includes(parseInt(record.birthday_day))) {
      record.birthday = `${record.birthday_year}-${record.birthday_month}-${record.birthday_day}`
    }

    if (![0, NaN].includes(parseInt(record.last_contact_year)) &&
     ![0, NaN].includes(parseInt(record.last_contact_month)) &&
     ![0, NaN].includes(parseInt(record.last_contact_day))) {
      record.last_contacted = `${record.last_contact_year}-${record.last_contact_month}-${record.last_contact_day}`
    }

    // Data we add 'manually'
    record.updated_at = record.updated_at || moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    record.notable_type = 'PyrCrm::Contact'
    record.home_label = 'home'
    record.mobile_label = 'cell'
    const phone = String(record.phone_number1).length > 0 ? record.phone_number1 : record.phone_number2
    record.phone_number = String(phone).replace(/ /g, '-')
    record.icentris_client = client
    const personId = crypto.createHash('md5').update(dataForPersonID).digest('hex').slice(0, 16)
    record.customer_person_id_esuite = personId
    // contact source:
    if (record.contact_source === 'customerManager') {
      record.source = 7
    } else {
      record.source = 1
    }

    const getUserId = async (consultantId) => {
      if (userIds.has(consultantId)) {
        return userIds.get(consultantId)
      }
      return null
    }

    return getUserId(record.consultant_id)
      .then(userId => {
        if (userId) {
          record.user_id = userId
          record.created_by = userId
          return record
        } else {
          return null
        }
      })
  }
}
module.exports = new TransformStupEsuiteContacts()
