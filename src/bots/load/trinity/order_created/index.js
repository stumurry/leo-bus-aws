'use strict'

const TrinityLoader = require('../bot')
const utils = require('../../../../libs/utils')

class OrderCreatedBot extends TrinityLoader {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'order_id',
      'dealer_id',
      'dealership_id',
      'tracking_number',
      'retail_value',
      'order_date',
      'personal_volume',
      'commission_volume',
      'autoship_template_id',
      'items',
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

  retailValueReducer (keyIn, objIn, objOut) {
    objOut.total = objIn[keyIn]
    return objOut
  }

  trackingNumberReducer (keyIn, objIn, objOut) {
    const trackingNumber = objIn.tracking_number
    objOut.tracking_numbers = [trackingNumber]
    return objOut
  }

  autoshipTemplateIdReducer (keyIn, objIn, objOut) {
    const autoshipTemplateId = objIn.autoship_template_id
    objOut.autoship_template = { id: parseInt(autoshipTemplateId) }
    return objOut
  }
}

module.exports = new OrderCreatedBot()
