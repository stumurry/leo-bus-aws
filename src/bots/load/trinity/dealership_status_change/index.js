const TrinityLoaderBot = require('../bot')

class DealershipStatusChange extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'status'
    ]
  }
}

module.exports = new DealershipStatusChange()
