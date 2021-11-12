'use strict'

const TrinityLoaderBot = require('../bot')

class CommissionBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'dealership_id',
      'dealer_id',
      'earnings',
      'payable_volume',
      'previous_balance',
      'balance_forward',
      'fee',
      'total',
      'bonuses',
      'commission_run'
    ]
  }

  bonusesReducer (keyIn, objIn, objOut) {
    objOut.commission_bonuses = objIn.bonuses

    for (var idx in objOut.commission_bonuses) {
      objOut.commission_bonuses[idx].bonus = objOut.commission_bonuses[idx].bonus_type
      delete objOut.commission_bonuses[idx].bonus_type
    }

    return objOut
  }

  commissionRunReducer (keyIn, objIn, objOut) {
    // add period_type_id if doesn't exist
    objOut.commission_run = objIn.commission_run
    if (!this.isPresent(objIn.commission_run.period.period_type_id)) {
      // 20 is default monthly
      objOut.commission_run.period.period_type_id = '20'
    }

    objOut.commission_run.period.client_period_id = objIn.commission_run.period.period_id
    delete objOut.commission_run.period.period_id

    return objOut
  }
}

module.exports = new CommissionBot()
