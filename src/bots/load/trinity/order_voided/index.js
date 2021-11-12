'use strict'

const TrinityLoaderBot = require('../bot')
const utils = require('../../../../libs/utils')

class OrderVoidedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'order_id',
      'voided_date',
      'dealer_id',
      'dealership_id',
      'status'
    ]
  }

  payloadReducer (keyIn, objIn, objOut) {
    const defaultedKeys = ['status']
    const customReducer = utils.snakeToCamel(keyIn) + 'Reducer'

    if (!objIn[keyIn] && defaultedKeys.includes(keyIn)) {
      this[customReducer](keyIn, objIn, objOut)
    }

    return super.payloadReducer(keyIn, objIn, objOut)
  }

  statusReducer (keyIn, objIn, objOut) {
    objOut[keyIn] = {
      id: 9,
      description: 'Cancelled'
    }
    return objOut
  }
}

module.exports = new OrderVoidedBot()
