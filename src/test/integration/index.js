'use strict'

const leoMock = require('../mocks/leo')
const s3Mock = require('../mocks/s3')
const Bot = require('../../bots/bot')

module.exports = (opts) => {
  before(async () => {
    leoMock.mock(opts.bus)
    s3Mock.mock()

    Bot.originalGetRemoteConfig = Bot.prototype.getRemoteConfig
    Bot.prototype.getRemoteConfig = async function () {
      return require('../config.json')
    }

    opts.getBot = (name) => {
      let bot
      try {
        bot = require(`../../bots/${name}/index`)
        bot.bus = opts.bus
      } catch (err) {
        const Bot = require(`../../bots/${name}`)
        bot = new Bot(opts.bus)
      }

      return bot
    }
  })

  beforeEach(() => {
    opts.start = new Date()
  })

  afterEach(() => {
    opts.bus.outQueueData = []
    opts.bus.inQueueData = []
  })

  after(() => {
    Object.keys(require.cache).map(key => {
      delete require.cache[key]
    })

    Bot.prototype.getRemoteConfig = Bot.originalGetRemoteConfig

    leoMock.unmock(opts.bus)
    s3Mock.unmock()
  })

  opts.describeTests([
    'libs/bus',
    'libs/mysql',
    'libs/utils',
    'libs/maxcdc',
    'libs/victorops',
    'bots/bot',
    'bots/map/mapper',
    'bots/map/bot',
    'bots/map/user',
    'bots/map/order',
    'bots/map/commission',
    'bots/map/subscription',
    'bots/map/summary_data',
    'bots/map/tree_node',
    'bots/load/max-cdc/cdc',
    'bots/load/maxscale/cdc',
    'bots/load/exigo/users',
    'bots/load/exigo/orders',
    'bots/load/exigo/subscriptions',
    'bots/load/exigo/customer_summary_data',
    'bots/load/exigo/commissions',
    'bots/load/exigo/tree_node',
    'bots/load/ingress-proxy/user',
    'bots/load/exigo/period_summary_data',
    'bots/load/trinity/bot',
    'bots/load/trinity/order_created',
    'bots/load/trinity/tracking_updated',
    'bots/load/trinity/commission',
    'bots/load/trinity/commission_updated',
    'bots/load/trinity/customer_enrollment',
    'bots/load/trinity/dealer_updated',
    'bots/load/trinity/dealership_enroller_changed',
    'bots/load/trinity/dealership_promote_demote',
    'bots/load/trinity/dealership_created',
    'bots/load/trinity/dealership_updated',
    'bots/load/trinity/dealership_deleted',
    'bots/load/trinity/dealership_ranks_updated',
    'bots/load/trinity/dealership_sponsorship_changed',
    'bots/load/trinity/dealership_status_change',
    'bots/load/trinity/order_updated',
    'bots/load/trinity/dealership_ownership_transfer',
    'bots/load/trinity/order_voided.js',
    'bots/load/trinity/order_voided',
    'bots/load/trinity/summary_data',
    'bots/load/sns/health_check_failed',
    'bots/load/vibe/message',
    'bots/load/vibe/message-recipient',
    'bots/load/vibe/user',
    'bots/load/vibe/site',
    'bots/load/vibe/site-visitor',
    'bots/load/vibe/site-analytic',
    'bots/load/vibe/task',
    'bots/load/vibe/order',
    'bots/load/vibe/order-item',
    'bots/load/vibe/package-json',
    'bots/load/vibe/contact',
    'bots/offload/s3',
    'bots/offload/vibe/bot',
    'bots/offload/vibe/order_aggregation',
    'bots/offload/vibe/users',
    'bots/offload/vibe/user_types',
    'bots/offload/vibe/commission',
    'bots/offload/vibe/subscriptions',
    'bots/offload/vibe/tree_period_data',
    'bots/offload/vibe/tree_placements',
    'bots/offload/vibe/tree_sponsors',
    'bots/offload/vibe/tree_user_plus',
    'bots/offload/vibe/upline_tree_rebuild',
    'bots/offload/vibe/tree_node',
    'bots/offload/victorops/health_check_errors',
    'bots/offload/vibe/orders',
    'bots/passthru/bot',
    'bots/passthru/summary_data',
    'bots/passthru/subscription',
    'bots/passthru/user_types',
    'bots/passthru/tree_node',
    'bots/passthru/autoship_user_types',
    'bots/vibe/jobs',
    'bots/vibe/refresh_request',
    'bots/one_time/offload_stup_esuite_contacts',
    'bots/one_time/transform_stup_esuite_contacts',
    'bots/one_time/import_stup_esuite_contacts',
    'e2e/trinity/customer_enrollment',
    'bots/fetch/trinity/summary_data',
    'bots/plmb/utc_transform/bot',
    'bots/plmb/utc_transform/summary_data',
    'bots/plmb/utc_transform/commission',
    'bots/plmb/utc_transform/user',
    'bots/plmb/utc_transform/order',
    'bots/plmb/utc_transform/subscription',
    'bots/plmb/utc_transform/tree_node'
  ].map(t => `./integration/${t}`))
}
