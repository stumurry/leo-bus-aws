'use strict'

const TrinityLoaderBot = require('../bot')

class TrackingUpdatedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'order_id',
      'tracking_numbers'
    ]
  }
}

module.exports = new TrackingUpdatedBot()
