'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(async () => {
    bot = opts.getBot('load/sns/health_check_failed')

    opts.event.Records = [
      {
        Sns: {
          Message: healthMessage()
        }
      }]
  })

  describe('#handle', () => {
    it('should load 6 bots', async () => {
      await bot.handle(opts.event, opts.context)
      // console.log('outqueuedata', opts.bus.outQueueData)
      // 3 bots with sourceLag, 2 rogue bots, 1 error bot... and a partridge in a pear tree...
      assert.strictEqual(opts.bus.outQueueData.length, 6)
    })
    it('should offload payloads with a truthy entity_id', async () => {
      await bot.handle(opts.event, opts.context)
      assert(opts.bus.outQueueData[0].payload.entity_id, `entity_id '${opts.bus.outQueueData[0].payload.entity_id}' isn't truthy`)
    })
    it('should not barf given unexpected message format', async () => {
      opts.event.Records[0].Sns.Message = 'Unexpected Message'
      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 0)
    })
  })
}

const healthMessage = () => {
  return 'If you would like to mute a bot or see your dashboard click or visit the link below:\n' +
    'https://125wgnfldk.execute-api.us-west-2.amazonaws.com/Release\n\n\n' +
    'Bot Health Report:\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:dw_order_loader\n' +
    'source_lag - 21d, 3h > 2m, 30s\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:some_error_bot\n' +
    'errors - 2 > 1\n\n' +
    'Bot Name - Order Generator\n' +
    'Bot Id - bot:order_generator\n' +
    'write_lag - 12d, 22h > 10m\n\n' +
    'Bot Name - simple_bot\n' +
    'Bot Id - bot:simple_bot\n' +
    'Bot Status: Rogue\n' +
    'source_lag - 52d > 4m\n' +
    'write_lag - 51d, 23h > 10m\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:resetCheckpoint_Main2\n' +
    'write_lag - 45m, 19s > 0s\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:TriggerBot\n' +
    'Bot Status: Rogue\n' +
    'errors - 3 > 1.5\n' +
    'write_lag - 117d, 8h > 10m\n' +
    'source_lag - 188d, 2h > 2m, 30s\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:order_changes\n' +
    'source_lag - 13d, 2h > 2m, 30s\n\n' +
    'Bot Name - copy_events1Changed\n' +
    'Bot Id - bot:copy_events\n' +
    'write_lag - 117d, 8h > 1h, 40m\n\n' +
    'Bot Name - N/A\n' +
    'Bot Id - bot:orders_entity_loader\n' +
    'source_lag - 13d, 2h > 2m, 30s\n\n\n'
}
