'use strict'

const Mapper = require('./mapper')
const Bot = require('../bot')

class MapBot extends Bot {
  constructor (bus) {
    super(bus)
    this.mappers = {}
  }

  async getMapper (client) {
    if (!this.mappers[client]) {
      const db = await this.getVibeDB(client)

      this.mappers[client] = new Mapper(db)
    }

    return this.mappers[client]
  }

  async handle (event, context) {
    super.handle(event, context)

    return this.transform(
      this.botId,
      event.source,
      event.destination,
      (payload, meta, done) => {
        this.each(payload)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null, true)
            }
          })
          .catch(err => {
            let errMsg = err
            let doneObj = err
            if ('sqlState' in err && err.sqlState === undefined) {
              errMsg = `Database connection error: ${err}`
              doneObj = null
            }
            console.log(errMsg)
            return done(doneObj)
          })
      }
    ).then(() => {
      return this.closeAllVibeDBs().then(() => {
        this.mappers = {}
      })
    }).catch(async (err) => {
      await this.closeAllVibeDBs()
      this.mappers = {}
      throw err
    })
  }
}

module.exports = MapBot
