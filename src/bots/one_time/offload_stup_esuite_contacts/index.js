const Bot = require('../../bot')
const _ = require('lodash')
const tables = {
  pyr_contacts: require('./pyr_contacts.json'),
  pyr_contact_emails: require('./pyr_contact_emails.json'),
  pyr_notes: require('./pyr_notes'),
  pyr_contact_phone_numbers: {
    home_phone: require('./pyr_contact_phone_numbers/home_phone.json'),
    mobile_phone: require('./pyr_contact_phone_numbers/mobile_phone.json')
  }
}

class OffloadStupEsuiteContacts extends Bot {
  constructor (bus) {
    super(bus)
    this.streams = {}
  }

  async handle (event, context) {
    super.handle(event, context)
    const { source } = event
    const botId = this.botId
    let errorLogger
    return this.bus.offload(
      botId,
      source,
      (payload, meta, done) => {
        const inObj = payload
        this.each(inObj, meta)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null)
            }
          })
          .catch(err => {
            errorLogger = {
              client: payload.icentris_client,
              eid: meta.eid,
              errEvent: event,
              err,
              errPayload: payload
            }
            done(err)
          })
      }
    )
      .then(() => {
        if (errorLogger) {
          const { client, eid, errEvent, err, errPayload } = errorLogger
          return this.bus.writeError(client, eid, errEvent, err, errPayload)
        }
      })
      .then(() => {
        if (errorLogger) return this.endErrorStream()
      })
      .then(() => {
        this.streams = {}
        return this.closeAllVibeDBs()
      }).catch(async (err) => {
        await this.closeAllVibeDBs()
        this.streams = {}
        throw err
      })
  }

  async getTableWriteStream (client, tbl, opts = {}) {
    if (!this.streams[client]) {
      this.streams[client] = {}
    }

    if (!this.streams[client][tbl]) {
      this.streams[client][tbl] = await this.getVibeDB(client).then(c => {
        return c.streamToTable(tbl, Object.assign({ useReplaceInto: true, client: client, event: this.event }, opts))
      })
    }

    return this.streams[client][tbl]
  }

  async endAllWriteStreams () {
    const promises = []
    Object.keys(this.streams).map(client => {
      return Object.keys(this.streams[client]).map(table => {
        promises.push(this.endWriteStream(client, table))
      })
    })

    return this.bus.Promise.all(promises)
  }

  translate (map, obj) {
    const ret = {}
    _.forOwn(map, (newField, oldField) => {
      if (_.has(obj, oldField)) {
        ret[newField] = _.get(obj, oldField)
      }
    })

    return ret
  }

  getClientMap (map, client) {
    return Object.assign(map.default, map[client] || {})
  }

  async each (payload, meta) {
    const client = payload.icentris_client
    const finalContacts = this.translate(this.getClientMap(tables.pyr_contacts, client), payload)
    return this.tableStream(finalContacts, client, 'pyr_contacts', meta)
      .then(() => {
        return this.getVibeDB(client)
      }).then(db => {
        const personId = payload.customer_person_id_esuite
        const select = `
        SELECT
          uc.id
        FROM pyr_contacts uc
        WHERE uc.customer_person_id_esuite = '${personId}'
          `
        return db.query(select)
      }).then(r => {
        r = r[0]
        if (r && r.length > 0) {
          return this.streamDependableTables({ contact_id: r[0].id, ...payload }, meta)
        } else {
          return this.notInsertedRowStream(
            {
              message: 'contact do not exist',
              payload: payload
            }, 'pyr_contacts')
        }
      })
  }

  notInsertedRowStream (payload, table) {
    const destination = 'stup-not-inserted-rows-esuite-contacts'
    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(destination))

    stream.on('error', err => {
      console.log('stream errored', err)
    })

    stream.write({
      table,
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

  tableStream (final, client, table, meta) {
    return this.getTableWriteStream(client, table)
      .then(stream => {
        stream.on('error', err => {
          console.log('stream errored', err)
        })

        stream.write({
          eid: meta.eid,
          record: final
        })

        return new this.bus.Promise((resolve, reject) => {
          stream.end(err => {
            if (err) {
              reject(err)
            } else {
              delete this.streams[client][table]
              resolve()
            }
          })
        })
      })
  }

  async streamDependableTables (payload, meta) {
    const client = payload.icentris_client
    const tablePromises = []
    if (!payload.email_address) {
      this.notInsertedRowStream(
        {
          message: 'There is not email',
          payload: payload
        }, 'pyr_contact_emails')
    } else {
      const finalEmails = this.translate(this.getClientMap(tables.pyr_contact_emails, client), payload)
      tablePromises.push(this.tableStream(finalEmails, client, 'pyr_contact_emails', meta))
    }
    if (!payload.notable_type) {
      this.notInsertedRowStream(
        {
          message: 'There is not notable_type',
          payload: payload
        }, 'pyr_notes')
    } else {
      const finalNotes = this.translate(this.getClientMap(tables.pyr_notes, client), payload)
      tablePromises.push(this.tableStream(finalNotes, client, 'pyr_notes', meta))
    }

    if (!payload.phone_number1) {
      this.notInsertedRowStream(
        {
          message: 'There is not home_phone',
          payload: payload
        }, 'pyr_contact_phone_numbers')
    } else {
      const finalPhone = this.translate(this.getClientMap(tables.pyr_contact_phone_numbers.home_phone, client), payload)
      tablePromises.push(this.tableStream(finalPhone, client, 'pyr_contact_phone_numbers', meta))
    }

    if (!payload.phone_number2) {
      this.notInsertedRowStream(
        {
          message: 'There is not mobile phone',
          payload: payload
        }, 'pyr_contact_phone_numbers')
    } else {
      const finalMobile = this.translate(this.getClientMap(tables.pyr_contact_phone_numbers.mobile_phone, client), payload)
      tablePromises.push(this.tableStream(finalMobile, client, 'pyr_contact_phone_numbers', meta))
    }

    return this.bus.Promise.all(tablePromises)
  }
}

module.exports = new OffloadStupEsuiteContacts()
