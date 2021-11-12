'use strict'

const moment = require('moment')
const clonedeep = require('lodash.clonedeep')

class Mapper {
  constructor (mysql) {
    this.mysql = mysql
  }

  lookupId (data, opts, ticker = 3) {
    if (!data[opts.lookupField]) {
      return Promise.resolve(null)
    }

    const select = this.mysql.squel.select()
      .field(opts.primaryKeyField)
      .from(opts.tbl)
      .where(opts.lookupField + ' = ?', data[opts.lookupField])
      .toParam()

    return this.mysql.execute(select.text, select.values)
      .then(rs => {
        rs = rs[0]
        if (rs.length > 0) {
          return rs[0][opts.primaryKeyField]
        } else {
          const insert = this.mysql.squel.insert()
            .into(opts.tbl)
            .setFields(data)
            .toParam()

          return this.mysql.execute(insert.text, insert.values)
            .then(rs => {
              rs = rs[0]
              if (opts.doLookupAfterInsert !== true && rs.insertId) {
                return rs.insertId
              } else {
                return this.lookupId(data, opts)
              }
            }).catch(err => {
              if (ticker > 0 && err.code && err.code === 'ER_DUP_ENTRY') {
                return new Promise((resolve, reject) => {
                  setTimeout(() => {
                    resolve()
                  }, Math.abs(3 - ticker) * 1000)
                }).then(() => {
                  return this.lookupId(data, opts, ticker - 1)
                })
              } else {
                throw err
              }
            })
        }
      })
  }

  treeUserId (clientUserId) {
    return this.lookupId({ client_user_id: clientUserId }, {
      lookupField: 'client_user_id',
      primaryKeyField: 'id',
      tbl: 'tree_users'
    })
  }

  bonusId (data) {
    return this.lookupId(Object.assign({
      created_at: moment().format('YYYY-MM-DD HH:mm:ss'),
      updated_at: moment().format('YYYY-MM-DD HH:mm:ss')
    }, data), {
      lookupField: 'id',
      primaryKeyField: 'id',
      tbl: 'tree_bonuses'
    })
  }

  runStatusId (data) {
    return this.lookupId(Object.assign({
      created_date: moment().format('YYYY-MM-DD HH:mm:ss')
    }, data), {
      lookupField: 'id',
      primaryKeyField: 'id',
      tbl: 'tree_commission_run_statuses'
    })
  }

  periodId (data, options = {}) {
    return this.lookupId(data, {
      lookupField: options.lookupField || 'client_period_id',
      primaryKeyField: 'id',
      tbl: 'tree_periods'
    })
  }

  /**
   * Upsert period/type data and lookup period type id and period id
   *
   * @param {object} period has <client_period_id> as id/client_period_id and a nested {object} type
   * @return {function <Promise>} returns a promise that resolves to the <period_id>
   */
  period (period) {
    return this.periodTypeId(period.type).then(typeId => {
      const clientPeriodId = period.client_period_id || period.id

      Object.assign(period.type, { period_type_id: typeId })

      Object.assign(period, { period_type_id: typeId, client_period_id: clientPeriodId })

      const periodFields = clonedeep(period)
      delete periodFields.type
      delete periodFields.id

      return this.periodId(periodFields)
    })
  }

  runId (data) {
    return this.lookupId(Object.assign({
      created_date: moment().format('YYYY-MM-DD HH:mm:ss')
    }, data), {
      lookupField: 'id',
      primaryKeyField: 'id',
      tbl: 'tree_commission_runs'
    })
  }

  periodTypeId (data) {
    const lookupField = data.id ? 'id' : 'description'
    return this.lookupId(data, {
      lookupField,
      primaryKeyField: 'id',
      tbl: 'tree_period_types'
    })
  }

  parentId (data) {
    return this.lookupId(data, {
      lookupField: 'client_parent_id',
      primaryKeyField: 'id',
      tbl: 'tree_users'
    })
  }

  sponsorId (data) {
    return this.lookupId(data, {
      lookupField: 'client_sponsor_id',
      primaryKeyField: 'id',
      tbl: 'tree_users'
    })
  }

  rankId (data) {
    return this.lookupId(Object.assign({
      level: data.client_level * 10,
      created_at: moment().format('YYYY-MM-DD HH:mm:ss'),
      updated_at: moment().format('YYYY-MM-DD HH:mm:ss')
    }, data), {
      lookupField: 'client_level',
      primaryKeyField: 'level',
      tbl: 'pyr_rank_definitions'
    })
  }

  typeId (data) {
    return this.lookupId(data, {
      lookupField: 'id',
      primaryKeyField: 'id',
      tbl: 'tree_user_types'
    })
  }

  userStatusId (data) {
    return this.lookupId(data, {
      lookupField: 'id',
      primaryKeyField: 'id',
      tbl: 'tree_user_statuses'
    })
  }

  contactId (clientUserId) {
    return this.treeUserId(clientUserId)
      .then(id => {
        return this.lookupId({ tree_user_id: id }, {
          lookupField: 'tree_user_id',
          primaryKeyField: 'id',
          tbl: 'pyr_contacts'
        })
      })
      .then(id => {
        return id
      })
  }

  userId (clientUserId) {
    return this.lookupId({ consultant_id: clientUserId }, {
      lookupField: 'consultant_id',
      primaryKeyField: 'id',
      tbl: 'users'
    })
  }

  treeUserPlusId (clientUserId) {
    return this.treeUserId(clientUserId)
      .then(id => {
        return this.lookupId({ tree_user_id: id }, {
          lookupField: 'tree_user_id',
          primaryKeyField: 'tree_user_id',
          tbl: 'tree_user_plus'
        })
      })
      .then(id => {
        return id
      })
  }
}

module.exports = Mapper
