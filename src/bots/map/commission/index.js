'use strict'

const MapBot = require('../bot')

class CommissionBot extends MapBot {
  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        const promises = {}
        promises.tree_user_id = mapper.treeUserId(payload.client_user_id)

        const commissionBonuses = new Array(payload.commission_bonuses.length).fill({})
        for (const bonus in payload.commission_bonuses) {
          commissionBonuses[bonus] = mapper.bonusId(payload.commission_bonuses[bonus].bonus)
        }

        let statusId
        promises.commission_run_id = mapper.runStatusId(payload.commission_run.status)
          .then(_statusId => {
            Object.assign(payload, { commission_run_status_id: _statusId })
            statusId = _statusId
            return mapper.period(payload.commission_run.period)
          })
          .then(_periodId => {
            const periodTypeId = payload.commission_run.period.period_type_id
            Object.assign(payload, { period_id: _periodId, period_type_id: periodTypeId })
            return mapper.runId({
              id: payload.commission_run.id,
              description: payload.commission_run.description,
              run_date: payload.commission_run.run_date,
              accepted_date: payload.commission_run.accepted_date,
              client_period_id: payload.commission_run.period.client_period_id,
              client_period_type_id: periodTypeId,
              commission_run_status_id: statusId,
              period_id: _periodId
            })
          })
        return Promise.all(commissionBonuses)
          .then(bonuses => {
            for (const index in bonuses) {
              payload.commission_bonuses[index].bonus_id = bonuses[index]
            }
            return this.bus.Promise.props(promises)
          })
      })
      .then(rs => {
        return Object.assign(rs, payload)
      })
  }
}

module.exports = new CommissionBot()
