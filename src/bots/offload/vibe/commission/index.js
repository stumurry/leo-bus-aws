'use strict'

const moment = require('moment')
const VibeOffloadBot = require('../bot')

const tableMaps = {
  commissions: require('./commissions.json'),
  bonuses: require('./bonuses.json')
}

class CommissionOffloadBot extends VibeOffloadBot {
  async each (payload, meta) {
    await this.getVibeDB(payload.icentris_client)
    const commissionStream = await this.getTableWriteStream(payload.icentris_client, 'tree_commissions')
    const bonusStream = await this.getTableWriteStream(payload.icentris_client, 'tree_commission_bonuses')
    const commission = this.translate(this.getClientMap(tableMaps.commissions, payload.icentris_client), payload)
    commission.tree_user_id = payload.tree_user_id
    delete commission.id
    delete commission.commission_run_status_id
    delete commission.period_id
    commissionStream.write({ eid: meta.eid, record: commission })

    if (payload.commission_bonuses) {
      payload.commission_bonuses.map((iMap, k) => {
        const mybonus = payload.commission_bonuses[k]
        iMap = payload.commission_bonuses[k].bonus
        iMap.commission_run_id = payload.commission_run.id
        iMap.bonus_id = mybonus.bonus_id
        iMap.amount = mybonus.amount
        iMap.customer_id = payload.client_user_id
        iMap.created_at = moment().format('YYYY-MM-DD HH:mm:ss')
        iMap.updated_at = moment().format('YYYY-MM-DD HH:mm:ss')
        iMap = this.translate(this.getClientMap(tableMaps.bonuses, payload.client_code), iMap)
        delete iMap.description
        bonusStream.write({ eid: meta.eid, record: iMap })
      })
    }
  }
}

module.exports = new CommissionOffloadBot()
