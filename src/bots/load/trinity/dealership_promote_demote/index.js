const TrinityLoaderBot = require('../bot')

class DealershipPromoteDemote extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'rank'
    ]
  }
}

module.exports = new DealershipPromoteDemote()
