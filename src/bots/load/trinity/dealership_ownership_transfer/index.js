'use strict'

const TrinityLoaderBot = require('../bot')

class DealershipOwnershipTransfer extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'dealer',
      'sponsor',
      'enroller'
    ]
  }
}

module.exports = new DealershipOwnershipTransfer()
