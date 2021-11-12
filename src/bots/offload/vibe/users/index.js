'use strict'
const _ = require('lodash')
const VibeOffloadBot = require('../bot')
const moment = require('moment')

// 'null' means 1:1 (payload:entries) and no custom map path - mee 8/8/18
const initialTablesWithMaps = {
  tree_users: require('./tree_users.json'),
  pyr_contacts: require('./pyr_contacts.json')
}

// 'null' means 1:1 (payload:entries) and no custom map path - mee 8/8/18
// an array means 1:many (payload:entries) - mee 8/8/18
const dependentTablesWithMaps = {
  pyr_contact_sources: require('./pyr_contact_sources.json'),
  pyr_contact_emails: require('./pyr_contact_emails.json'),
  // pyr_contacts_contact_categories: require('./pyr_contacts_contact_categories.json'),
  pyr_contact_phone_numbers: {
    home_phone: require('./pyr_contact_phone_numbers/home_phone.json'),
    mobile_phone: require('./pyr_contact_phone_numbers/mobile_phone.json')
  }
}

const initialTables = Object.keys(initialTablesWithMaps)
const dependentTables = Object.keys(dependentTablesWithMaps)

// used by tests for truncation - mee 8/6/18
const offloadTables = initialTables.concat(dependentTables)

class UserOffloadBot extends VibeOffloadBot {
  async each (payload) {
    if (!payload.tree_user_id) {
      throw new Error('Tree User Id not set from MapUser')
    }

    const client = payload.icentris_client

    const write = async ([table, payload, map, queryKey, primaryKey]) => {
      const db = await this.getVibeDB(client)
      const clientMap = this.getClientMap(map, client)
      const transformed = Object.assign(payload, this.applyTransforms(payload, table, clientMap))
      const final = this.translate(clientMap, transformed)
      return db.upsert(table, final, queryKey, primaryKey)
    }

    // avoids race condition in implementation of this method - ndg 8/10/18
    await this.getVibeDB(client)

    return write(['pyr_contacts', payload, initialTablesWithMaps.pyr_contacts, 'tree_user_id', 'id'])
      .then(contact => {
        return this.bus.Promise.map([[
          'tree_users',
          payload,
          initialTablesWithMaps.tree_users,
          'id'
        ], [
          'pyr_contact_sources',
          payload,
          dependentTablesWithMaps.pyr_contact_sources,
          ['contact_id', 'system_type']
        ], [
          'pyr_contact_emails',
          payload,
          dependentTablesWithMaps.pyr_contact_emails,
          ['contact_id', 'email']
        ], [
          'pyr_contact_phone_numbers',
          payload,
          dependentTablesWithMaps.pyr_contact_phone_numbers.home_phone,
          ['contact_id', 'label', 'unformatted_phone_number']
        ], [
          'pyr_contact_phone_numbers',
          payload,
          dependentTablesWithMaps.pyr_contact_phone_numbers.mobile_phone,
          ['contact_id', 'label', 'unformatted_phone_number']
        ]/* , [
          'pyr_contacts_contact_categories',
          payload,
          dependentTablesWithMaps.pyr_contacts_contact_categories,
          ['contact_id', 'contact_category_id']
        ] */], write, { concurrency: 6 })
      })
  }

  /**
   * @author: matt ewell
   *  @since: 8/3/2018
   *  @summary: Add the label for a filtered phone object
   *  @description: 'label' is a key in the vibe db that corresponds with the type of phone
       number. We just need to find out what type it is based on the key in the mapped user
       object. So a 'home_phone':<number> key/value will correspond to 'label': 'home' in
       pyr_contact_phone_numbers.
   **/

  pyrContactPhoneNumbersOffloadTransforms (inObj, tableName, map) {
    const outObj = {}
    if (_.has(map, 'mobile_phone')) {
      outObj.mobile_phone_label = 'cell'
    } else if (_.has(map, 'home_phone')) {
      outObj.home_phone_label = 'home'
    }
    return outObj
  }

  pyrContactSourcesOffloadTransforms () {
    return { system_type: 'databus' }
  }

  treeUsersOffloadTransforms (inObj) {
    const outObj = {}
    let clientSponsorId, clientParentId

    try {
      clientSponsorId = inObj.upline.client_sponsor_id
      if (typeof clientSponsorId === 'string') {
        outObj.client_sponsor_id = clientSponsorId
      }
    } catch (err) {
      // if we get here, there's no inObj.upline object. just ignoring. - mee 7/24/18
    }

    try {
      clientParentId = inObj.upline.client_parent_id
      if (typeof clientParentId === 'string') {
        outObj.client_parent_id = clientParentId
      }
    } catch (err) {
      // if we get here, there's no inObj.upline object. just ignoring. - mee 7/24/18
    }

    return outObj
  }

  pyrContactsOffloadTransforms (inObj, tableName, map) {
    /*
      1. Grab any "extra" fields that are not mapped and place them in "custom_json_data" as a JSON string - jc 12/10/2018
      2. If inObj does not have updated_at, inject it with the current date/time UTC - jc 01/15/2019
    */
    const outObj = { custom_json_data: {} }

    Object.keys(_.get(inObj, 'extra', {}))
      .filter(k => {
        // console.log(`checking for key 'extra.${k}' in ${JSON.stringify(map, null, 2)}`)
        return !_.has(map, `extra.${k}`)
      })
      .forEach(k => {
        // console.log(`adding key ${k} to custom_json_data`)
        outObj.custom_json_data[k] = _.get(inObj, `extra.${k}`)
      })

    outObj.custom_json_data = JSON.stringify(outObj.custom_json_data)

    if (!_.has(inObj, 'updated_at')) {
      outObj.updated_at = moment(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    }

    return outObj
  }

  /**
   * @author m ewell
   * @since 8/2/2018
   * @summary A way to export this constant without using multiple exports
   **/
  affectedTables () { return offloadTables }
}

module.exports = new UserOffloadBot()
