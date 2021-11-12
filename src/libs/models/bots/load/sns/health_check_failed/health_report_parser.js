const _ = require('lodash')
const Log = require('../../../../../log')

function extractBots (healthReport) {
  let bots = []

  try {
    healthReport = healthReport.replace(/bot:/g, '') // Remove this string to make kv splitting simple

    const botLines = healthReport.split('\n\n\n')[1].split('\n\n')
    botLines.shift() // discard first line

    bots = botLines
      .map(line => line.split('\n'))
      .map(attrArray => {
        const pairs = attrArray.map(attr => {
          const kv = attr.split(/: | - /)
          kv[0] = _.camelCase(kv[0])
          kv[1] = kv[1].trim()
          return kv
        })
        return _.fromPairs(pairs)
      })
  } catch (e) {
    Log.error('DTM', `The following error occured parsing health report: ${e}`, { healthReport: healthReport })
  }

  return bots
}

function getReportableBots (healthReport) {
  const reportableStatuses = ['Rogue']
  const reportableAttributes = ['sourceLag', 'errors']
  const allBots = extractBots(healthReport)
  const bots = allBots
    .filter(bot => {
      return _.indexOf(reportableStatuses, bot.botStatus) > -1 || _.find(reportableAttributes, attr => _.has(bot, attr))
    })

  return bots
}

module.exports = {
  getReportableBots: getReportableBots
}
