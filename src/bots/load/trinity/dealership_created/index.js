'use strict'

const TrinityLoaderBot = require('../bot')
const utils = require('../../../../libs/utils')

// Test CLI
class DealershipCreatedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'dealer',
      'status',
      'rank',
      'sponsor',
      'enroller',
      'customer_type',
      'is_downline_contact'
    ]
  }

  async each (payload) {
    if (payload.icentris_client) {
      /*
      * This may be an upgrade. For efficiency sake we're just going to update. We need to update tree_users.client_user_id
      * and users.consultant_id so the subsequent bots map properly with this payload.
      *
      * E.g., payload.dealer.dealer_id = '11', payload.dealership_id = '22'.
      * Update a tree_user with a client_user_id of 'c11' to 'd22'
      * jc 1/22/19
      */
      const dealerId = payload.dealer ? payload.dealer.dealer_id : null
      const dealershipId = payload.dealership_id

      if (dealerId && dealershipId) {
        const db = await this.getVibeDB(payload.icentris_client)
        const update = `
        UPDATE
          tree_users tu
          LEFT JOIN users u on tu.id = u.tree_user_id
        SET
          tu.client_user_id = 'd${dealershipId}',
          u.consultant_id = 'd${dealershipId}'
        WHERE
          tu.client_user_id = 'c${dealerId}'`
        await db.execute(update)
      }

      return super.each(payload)
    } else {
      return null
    }
  }

  payloadReducer (keyIn, objIn, objOut) {
    const defaultedKeys = ['status', 'customer_type']
    const customReducer = utils.snakeToCamel(keyIn) + 'Reducer'
    if (!objIn[keyIn] && defaultedKeys.includes(keyIn)) {
      this[customReducer](keyIn, objIn, objOut)
    }
    objOut.is_downline_contact = true
    return super.payloadReducer(keyIn, objIn, objOut)
  }
}
module.exports = new DealershipCreatedBot()
