'use strict'

const Bot = require('../../../bot')
const Parser = require('../../../../libs/models/bots/load/sns/health_check_failed/health_report_parser')

class SNSBot extends Bot {
  async handle (event, context) {
    this.botId = 'LoadSNSHealthCheckFailed'

    const msg = event.Records ? event.Records[0].Sns.Message : 'Default Message'
    const stream = this.bus.leo.load(this.botId, this.bus.getQueue('health-check-errors'))

    stream.on('error', err => {
      console.log('stream errored', err)
    })

    const reportableBots = Parser.getReportableBots(msg)

    reportableBots.forEach(bot => {
      stream.write({
        message: JSON.stringify(bot, null, 2),
        entity_id: `leo-bus-${bot.botId}`
      })
    })

    return new this.bus.Promise((resolve, reject) => {
      stream.end(err => {
        if (err) {
          reject(err)
        } else {
          resolve()
        }
      })
    })
  }
}

module.exports = new SNSBot()
