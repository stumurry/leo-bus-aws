module.exports = (opts) => {
  const botJsonFile = require('./../../../../../bots/load/vibe/package.json')

  const assert = opts.assert
  describe('#validate load vibe package.json', () => {
    const variations = botJsonFile.config.leo.variations
    function settingsOccurrence (variations, key) {
      const t = botJsonFile.config.leo.variations.reduce((acc, v) => {
        const k = v.cron.settings.icentris_client + '-' + v.cron.settings[key]
        if (acc[k] !== undefined) {
          acc[k]++
        } else {
          acc[k] = 1
        }
        return acc
      }, {})
      return t
    }

    it('should not have duplicate CDC table', async () => {
      const tables = settingsOccurrence(variations, 'table')
      assert.deepEqual(Object.keys(tables).filter(k => tables[k] > 1), [])
    })
    it('should not have duplicate CDC destination', async () => {
      const tables = settingsOccurrence(variations, 'destination')
      assert.deepEqual(Object.keys(tables).filter(k => tables[k] > 1), [])
    })
    it('should not have duplicate CDC bot_id', async () => {
      const tables = settingsOccurrence(variations, 'bot_id')
      assert.deepEqual(Object.keys(tables).filter(k => tables[k] > 1), [])
    })
  })
}
