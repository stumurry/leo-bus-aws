'use strict'

const TrinityLoaderBot = require('../bot')

class OrderUpdatedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'order_id',
      'status'
    ]
  }

  statusReducer (keyIn, objIn, objOut) {
    const statusId = objIn[keyIn].status_id
    const description = objIn[keyIn].description

    if (statusId !== undefined) {
      objOut[keyIn] = { id: objIn[keyIn].status_id }
    }

    if (description !== undefined) {
      objOut[keyIn].description = objIn[keyIn].description
    }
    return objOut
  }
}

module.exports = new OrderUpdatedBot()
