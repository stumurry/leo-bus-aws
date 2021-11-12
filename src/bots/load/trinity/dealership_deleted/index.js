'use strict'

const TrinityLoaderBot = require('../bot')

class DealershipDeletedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'dealer',
      'rank',
      'sponsor',
      'enroller'
    ]
  }
}

module.exports = new DealershipDeletedBot()
