'use strict'

const TrinityLoaderBot = require('../bot')
const utils = require('../../../../libs/utils')

class CustomerEnrollmentBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'icentris_client',
      'dealer_id',
      'first_name',
      'last_name',
      'company_name',
      'home_phone',
      'fax_phone',
      'mobile_phone',
      'email',
      'address1',
      'address2',
      'city',
      'state',
      'postal_code',
      'county',
      'country',
      'signup_date',
      'customer_type',
      'birth_date',
      'sponsor',
      'status'
    ]
  }

  payloadReducer (keyIn, objIn, objOut) {
    const defaultedKeys = ['status', 'customer_type']
    const customReducer = utils.snakeToCamel(keyIn) + 'Reducer'
    if (!objIn[keyIn] && defaultedKeys.includes(keyIn)) {
      this[customReducer](keyIn, objIn, objOut)
    }
    return super.payloadReducer(keyIn, objIn, objOut)
  }
}

module.exports = new CustomerEnrollmentBot()
