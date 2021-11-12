'use strict'

const TrinityLoaderBot = require('../bot')

class DealershipSponsorshipChanged extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'sponsor'
    ]
  }
}

module.exports = new DealershipSponsorshipChanged()
