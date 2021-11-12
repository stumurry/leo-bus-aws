'use strict'

const Bot = require('../../bot')
const Log = require('../../../libs/log')
const maxcdc = require('../../../libs/maxcdc')
const victorops = require('../../../libs/victorops')

class LoadVibeCDCBot extends Bot {
  constructor (opts) {
    super(opts)

    /**
     * @author Jon Cain
     * @date 9/4/2019
     * @summary By default, write payloads to S3 (rather than Kinesis). Unit tests set this to false due to mock complexities.
     */
    this.useS3 = true
  }

  async handle (event, context) {
    Log.info(event.icentris_client, 'Calling Max CDC')
    Log.info(event.icentris_client, event)
    Log.info(event.icentris_client, context)

    const settings = Object.assign({
      runAgain: true,
      duration: context.getRemainingTimeInMillis() * 0.8
    }, event)
    const cfg = await this.getRemoteConfig()
    this.maxCdcCfg = cfg.bus.tenant[settings.icentris_client].maxscale
    const voCfg = cfg.victor_ops
    const ls = this.bus.leo.streams
    this.checkpoints = JSON.parse(await this.bus.leo.bot.getCheckpoint(context.botId, settings.source) || '{}')

    const noCheckpointCb = (table) => {
      victorops.writeToVictorOps(voCfg, {
        entity_id: context.botId,
        message: `Creating new CDC checkpoint for table: ${table} because none was found.`
      })
    }

    Log.info(event.icentris_client, `Vibe CDC piping changes from binary log to queue: ${settings.destination}-${settings.icentris_client}`)

    return new Promise((resolve, reject) => {
      ls.pipe(
        maxcdc.streamChanges(
          settings.tables,
          this.checkpoints,
          this.maxCdcCfg,
          noCheckpointCb
        ),
        maxcdc.formatPayload(settings.tables, this.checkpoints),
        this.log(ls, settings.icentris_client),
        ls.counter(settings.reportEvery),
        this.bus.leo.load(context.botId, `${settings.destination}-${settings.icentris_client}`, { useS3: this.useS3 }),
        (err) => {
          if (err) {
            reject(err)
          } else {
            resolve()
          }
        }
      )
    })
  }

  log (ls, icentrisClient) {
    return ls.through((obj, done) => {
      Log.info(icentrisClient, `Writing to leo.load ${JSON.stringify(obj)}`)
      done(null, obj)
    })
  }
}

module.exports = new LoadVibeCDCBot()
