'use strict'

const VibeOffloadBot = require('../bot')
const moment = require('moment')

const streamToTable = function (table, opts) {
  opts = Object.assign({
    records: 10000,
    useReplaceInto: false,
    onDupUpdate: false
  }, opts || {})
  const stream = this.bus.leo.streams.bufferBackoff((obj, done) => {
    done(null, obj, 1, 1)
  }, (records, callback) => {
    const sql = this.squel.insert()

    sql.into(table)

    const getEID = (rec) => {
      return rec.eid
    }

    const getRecord = (rec) => {
      return rec.record
    }

    if (Array.isArray(records)) {
      sql.setFieldsRows(records.map(r => getRecord(r)))
    } else {
      sql.setFields(getRecord(records))
    }

    const query = sql.toParam()
    query.values = query.values.map(v => {
      return v === undefined ? null : v
    })

    query.text += `\nON DUPLICATE KEY UPDATE
        subscription_plan_id = IF(VALUES(subscription_plan_id) >= subscription_plan_id, VALUES(subscription_plan_id), subscription_plan_id),
        next_billing_date = IF(VALUES(subscription_plan_id) >= subscription_plan_id, VALUES(next_billing_date), next_billing_date),
        active = IF(VALUES(subscription_plan_id) >= subscription_plan_id, VALUES(active), active)`

    this.execute(query.text, query.values)
      .then(rs => {
        callback(null, [])
      })
      .catch(err => {
        err.table = table
        err.query = sql.toString()

        this.bus.writeError(opts.client, records.map(r => getEID(r)), opts.event, err, records)

        callback(null, [])
      })
  }, {
    failAfter: 2
  }, {
    records: opts.records
  })

  stream.asyncEnd = () => {
    return new this.Promise((resolve, reject) => {
      stream.end(err => {
        if (err) {
          this.bus.writeError(opts.client, null, opts.event, err, null)
          resolve()
        } else resolve()
      })
    })
  }

  return stream
}

class OffloadVibeSubscriptionsBot extends VibeOffloadBot {
  async getTableWriteStream (client, tbl, opts = {}) {
    if (!this.streams[client]) {
      this.streams[client] = {}
    }

    if (!this.streams[client][tbl]) {
      this.streams[client][tbl] = await this.getVibeDB(client).then(c => {
        c.streamToTable = streamToTable
        return c.streamToTable(tbl, Object.assign({ useReplaceInto: true, client: client, event: this.event }, opts))
      })
    }

    return this.streams[client][tbl]
  }

  async each (payload, meta) {
    if ([null, '', 0, undefined].indexOf(payload.tree_user_id) > -1) {
      throw new Error(`payload.tree_user_id has an invalid value: '${payload.tree_user_id}'`)
    }

    const str = await this.getTableWriteStream(payload.icentris_client, 'pyr_subscriptions')
    str.write({
      record: {
        user_id: payload.user_id,
        subscription_plan_id: payload.subscription_plan_id,
        next_billing_date: moment(payload.expire_date).format('Y-M-D'),
        active: payload.active
      },
      eid: meta.eid
    })
  }
}

module.exports = new OffloadVibeSubscriptionsBot()
