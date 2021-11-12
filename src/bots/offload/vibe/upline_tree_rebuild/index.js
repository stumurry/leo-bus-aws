'use strict'

const Bot = require('../../../bot')
const customerTypes = require('../customer_types.json')
const Log = require('../../../../libs/log')

/**
  * @author Wington Brito
  * @since 03/22/2019
  * @summary. This class has two main functions in the pipeline:
  *  1. Offload the upline
  *  2. Determine if we need a tree rebuild
  * @description The class will upsert the Vibe upline and
  * subsequently insert the 'tree rebuild trigger' into dynamodb.
  * Prior to the upline upsert, the current Vibe upline is cached
  * and later use against the incoming payload to determe the tree rebuild
*/
class UplineMergeTreeRebuild extends Bot {
  async each (payload, meta) {
    if (!payload.tree_user_id) {
      console.log(Error('Tree User Id not set from MapUser'))
      return
    }
    if (!payload.upline) {
      return
    }

    let previousUplineRecord
    let mysqldb

    const client = payload.icentris_client
    return this.getVibeDB(client).then(db => {
      mysqldb = db
      const fields = ['user_type_id', 'parent_id', 'sponsor_id']
      return mysqldb.lookup('tree_users', { id: payload.tree_user_id }, { fields, lookupField: 'id' })
    }).then(upline => {
      previousUplineRecord = upline
      const row = {
        id: payload.tree_user_id
      }

      if (payload.sponsor_id && payload.upline.client_sponsor_id) {
        Object.assign(row, { sponsor_id: payload.sponsor_id, client_sponsor_id: payload.upline.client_sponsor_id })
      }

      if (payload.parent_id && payload.upline.client_parent_id) {
        Object.assign(row, { parent_id: payload.parent_id, client_parent_id: payload.upline.client_parent_id })
      }

      return mysqldb.upsert('tree_users', row, 'id')
    }).then(() => {
      if (meta.blacklisted_clients.includes(client)) return null
      return this.determineTreeRebuild(payload, previousUplineRecord[0])
    }).then(treeRebuild => {
      if (treeRebuild) {
        const items = []
        const types = treeRebuild.split('&')

        const client = payload.icentris_client
        const createdTime = Date.now()

        items.push({
          created_time: createdTime,
          icentris_client: client,
          type: types[0]
        })

        if (types.length > 1) {
          items.push({
            created_time: createdTime,
            icentris_client: client,
            type: types[1]
          })
        }
        return items
      } else {
        Log.info(client, `payload was not sent to dynamodb for ${client}`, {
          data: { original: payload, submitted: treeRebuild }
        })
      }
    }).catch(err => {
      throw new Error(`Thrown: ${err}`)
    })
  }

  handle (event, context) {
    super.handle(event, context)

    const ls = this.bus.leo.streams
    const settings = { ...event }
    const eventId = this.botId
    const queue = this.bus.getQueue(settings.source)

    const stats = ls.stats(eventId, queue)

    return new Promise((resolve, reject) => {
      const that = this
      ls.pipe(ls.fromLeo(eventId, queue), stats, ls.through(function (obj, done) {
        that.each(obj.payload, { blacklisted_clients: settings.blacklisted_clients }).then(forDynamo => {
          if (forDynamo) {
            forDynamo.forEach(item => this.push(item))
          }
          done(null)
        }).catch(err => done(err))
      }), ls.toDynamoDB(`tree-rebuild-requests-${process.env.NODE_ENV}`, { hash: 'icentris_client', range: 'type' }), err => {
        if (err) {
          reject(err)
        } else {
          stats.checkpoint(resolve)
        }
      })
    }).then(() => {
      this.streams = {}
      return this.closeAllVibeDBs()
    }).then(() => {
      this.mappers = {}
    }).catch(async err => {
      await this.closeAllVibeDBs()
      this.mappers = {}
      this.streams = {}
      throw err
    })
  }

  /**
    * @author Wington Brito
    * @since 03/22/2019
    * @param {} previousUplineRecord - old upline information parent_id, sponsor_id, client_parent_id, client_sponsor_id
    * @return {} type for treeRebuild payload
  */
  determineTreeRebuild (payload, previousUpline) {
    const userTypeId = parseInt(previousUpline.user_type_id) || parseInt(payload.type_id)
    const types = Object.assign(customerTypes.default, customerTypes[payload.icentris_client])
    const newUpline = {}

    newUpline.parent_id = !payload.parent_id ? null : parseInt(payload.parent_id)
    newUpline.sponsor_id = !payload.sponsor_id ? null : parseInt(payload.sponsor_id)

    previousUpline.parent_id = !previousUpline.parent_id ? null : parseInt(previousUpline.parent_id)
    previousUpline.sponsor_id = !previousUpline.sponsor_id ? null : parseInt(previousUpline.sponsor_id)

    if (!newUpline.parent_id && !newUpline.sponsor_id) return null

    if (userTypeId === types.customer || userTypeId === types.preferred_customer) {
      if (previousUpline.sponsor_id !== newUpline.sponsor_id) {
        return 'Sponsor'
      } else {
        return null
      }
    } else if (userTypeId === types.distributor) {
      if (previousUpline.sponsor_id !== newUpline.sponsor_id && previousUpline.parent_id !== newUpline.parent_id) {
        return 'Sponsor&Placement'
      } else if (previousUpline.sponsor_id !== newUpline.sponsor_id) {
        return 'Sponsor'
      } else if (previousUpline.parent_id !== newUpline.parent_id) {
        return 'Placement'
      } else {
        return null
      }
    }
  }
}

module.exports = new UplineMergeTreeRebuild()
