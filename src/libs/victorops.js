const request = require('superagent')

const writeToVictorOps = (voCfg, payload) => {
  if (!voCfg) throw new Error('Please provide a config object')
  if (!payload) throw new Error('Please provide a payload object')
  if (!voCfg.url) throw new Error('Config is missing url.')
  return request
    .post(voCfg.url)
    .send(victorOpsRequest(payload))
    .type('application/json')
}

const victorOpsRequest = (payload) => {
  return JSON.stringify({
    message_type: 'CRITICAL',
    entity_id: payload.entity_id,
    entity_display_name: `CDC Checkpoint Error - leo-bus-${process.env.NODE_ENV}`,
    state_message: payload.message
  })
}

module.exports = {
  writeToVictorOps: writeToVictorOps,
  victorOpsRequest: victorOpsRequest
}
