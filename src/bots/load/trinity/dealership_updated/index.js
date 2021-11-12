const TrinityLoaderBot = require('../bot')

class DealershipUpdated extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)
    this.whiteList = [
      'dealership_id',
      'position',
      'is_downline_contact'
    ]
  }

  payloadReducer (keyIn, objIn, objOut) {
    objOut.is_downline_contact = true
    return super.payloadReducer(keyIn, objIn, objOut)
  }

  positionReducer (keyIn, inObj, outObj) {
    const position = inObj.position
    outObj.upline = outObj.upline || {}
    outObj.upline.position = position

    return outObj
  }
}

module.exports = new DealershipUpdated()
