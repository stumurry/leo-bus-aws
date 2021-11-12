'use strict'

const TrinityLoaderBot = require('../bot')

class DealershipEnrollerChangedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'enroller'
    ]
  }
}

module.exports = new DealershipEnrollerChangedBot()
