'use strict'

const Bot = require('../../bot')
const _ = require('lodash')
const moment = require('moment')
const snakeToCamel = require('../../../libs/utils').snakeToCamel

class VibeOffloadBot extends Bot {
  constructor (bus) {
    super(bus)
    this.streams = {}
    this.maps = {}
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

  /**
   * @author m ewell
   * @since 7/24/2018
   * @summary Checks for functions named for the table being offloaded to and
   *   calls them.
   * @description
   *   translate() above takes a map and scalar fields. What about
   * the object fields you may need? That's what the applyTransforms path is
   * for. It looks for something named <table>OffloadTransforms and calls it. If
   * it's not present, it returns an empty object. Whatever is returned will be
   * merged with the existing object being prepared for offload.
   *   See treeUsersOffloadTransforms in the Users offload bot which takes two
   * Objects from the payload and maps them to the flat db structure.
   **/
  applyTransforms (inObj, tableName, map) {
    const transformFunction = this[snakeToCamel(tableName) + 'OffloadTransforms']
    if (typeof transformFunction === 'function') {
      return transformFunction.bind(this)(inObj, tableName, map)
    } else { return {} }
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

  async endWriteStream (client, table) {
    this.streams[client][table].asyncEnd()
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

  getClientMap (map, client) {
    return Object.assign(map.default, map[client] || {})
  }

  handle (event, context) {
    super.handle(event, context)
    return this.bus.offload(this.botId, event.source, async (payload, meta) => {
      return this.each(payload, meta)
        .catch(err => {
          this.bus.writeError(payload.icentris_client, meta.eid, event, err, payload)
        })
    }).then(() => {
      /* Write an ETL status record. This is used by Vibe to calculate last updated date for reports. See DTM-1005 */
      return Promise.all(Object.keys(this.clients).map(client => {
        return this.getVibeDB(client)
          .then(db => {
            return db.upsert('tree_etl_statuses', { tracking_id: 'data-bus', start_time: moment().format('YYYY-MM-DD H:m:s').toString(), file_name: `${event.source}-${event.botId}` }, 'file_name', 'id')
          }).catch(e => console.log('etl_status error', e))
      }))
    }).then(() => {
      const promises = [this.endErrorStream()]
      Object.keys(this.streams).map(cl => {
        return Object.keys(this.streams[cl]).map(t => {
          promises.push(this.streams[cl][t].asyncEnd())
        })
      })

      return this.bus.Promise.all(promises)
    }).then(() => {
      this.streams = {}
      return this.closeAllVibeDBs()
    }).then(() => {
      this.mappers = {}
    }).catch(async (err) => {
      await this.closeAllVibeDBs()
      this.mappers = {}
      this.streams = {}
      throw err
    })
  }
}

module.exports = VibeOffloadBot
