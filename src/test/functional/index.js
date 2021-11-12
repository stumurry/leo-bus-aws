'use strict'

module.exports = (opts) => {
  before(() => {
    opts.setOptsForBot = (botName, opts, variation) => {
      let prefix = (process.env.EXTUSER || '').replace(/\./gi, '-')

      if (prefix) {
        prefix += '-'
      }

      // so we don't keep nesting our prefix. but the timestamp throws this off.
      function addPrefix (prefix, target) {
        if (target.substring(0, prefix.length) === prefix) {
          return target
        }
        return prefix + target
      }

      const b = require(`../../bots/${botName}/index`)
      let cfg
      try {
        cfg = require(`../../bots/${botName}/package.json`)
      } catch (err) {
        cfg = require(`../../bots/${botName}/package.deprecated.json`)
      }

      Object.assign(opts, {
        config: cfg,
        bot: b,
        event: cfg.config.leo.cron.settings
      })

      if (variation) {
        var v = cfg.config.leo.variations.filter(vv => vv.name === variation)[0]
        Object.assign(opts.event, v.cron.settings)
      }

      const source = opts.event.source
      const queue = opts.event.queue

      if (source) opts.event.source = addPrefix(prefix, source)
      if (queue) opts.event.queue = addPrefix(prefix, queue)
      if (source && queue) {
        throw new Error('You cannot use both source and queue. Queue is for cron jobs, source is for events.')
      }

      const name = cfg.name

      var botId
      if (variation) {
        const camelCasedQueue = (source || queue)
          .split('-')
          .map(s => { return s.charAt(0).toUpperCase() + s.slice(1) })
          .join('')
        botId = addPrefix(prefix, `${name}-var-${camelCasedQueue}`)
      } else {
        botId = addPrefix(prefix, name)
      }

      opts.event.botId = botId
      opts.context.botId = botId

      const destination = opts.event.destination
      if (destination) {
        opts.event.destination = addPrefix(prefix, destination)
      }

      return opts
    }

    opts.createContext = () => {
      var start = new Date()
      var maxTime = module.exports.timeout || 300000000

      return {
        awsRequestId: 'requestid-local' + opts.moment.now().toString(),
        getRemainingTimeInMillis: function () {
          var timeSpent = new Date() - start
          if (timeSpent < maxTime) {
            return maxTime - timeSpent
          } else {
            return 0
          }
        }
      }
    }

    opts.checkpointForTest = async (opts, queue, checkpoint) => {
      const stream = opts.bus.Promise.promisify(opts.bus.leo.bot.checkpoint)

      return stream(opts.event.botId, opts.bus.getQueue(queue), {
        type: 'read',
        force: true,
        eid: checkpoint
      })
    }

    opts.setCheckpointsToCurrent = async (opts) => {
      opts.checkpoint = opts.moment().subtract(3, 'second').utc().format('[z/]YYYY/MM/DD/HH/mm/x')

      await opts.checkpointForTest(opts, opts.event.source, opts.checkpoint)
      if (opts.event.destination) {
        await opts.checkpointForTest(opts, opts.event.destination, opts.checkpoint)
      }
    }

    opts.checkEventsWritten = (queue, callback, ticker = 5) => {
      return opts.bus.leo.aws.dynamodb.get(
        opts.bus.leo.configuration.resources.LeoEvent,
        opts.bus.getQueue(queue),
        { id: 'event' },
        (err, data) => {
          if (err) callback(err)
          else {
            if ((data === undefined || data.max_eid < opts.checkpoint) && ticker >= 0) {
              const timeout = Math.abs(6 - ticker) * 1000
              setTimeout(() => {
                return opts.checkEventsWritten(queue, callback, --ticker)
              }, timeout)
            } else if (ticker === 0) {
              throw new Error('Events failed to write to dynamodb')
            } else {
              callback(null, data)
            }
          }
        })
    }

    opts.bootstrapSource = (opts, data) => {
      const stream = opts.bus.leo.load(opts.event.botId, opts.event.source || opts.event.queue)
      data.map(e => {
        stream.write(e)
      })

      return new opts.mysql.Promise((resolve, reject) => {
        stream.end(err => {
          if (err) {
            reject(err)
          } else {
            opts.checkEventsWritten(opts.event.source, (err, data) => {
              if (err) reject(err)
              else resolve(data)
            })
          }
        })
      })
    }
  })

  const tests = [
    'bot',
    'load/trinity/tracking_updated',
    'map/user',
    'map/order',
    'offload/splunk/errors',
    'offload/vibe/orders',
    'offload/vibe/tree/placements',
    'vibe/jobs',
    'vibe/refresh_request',
    'offload/gcp/bigquery/message',
    'offload/s3/contact_categories',
    'offload/gcp/gcs/aws_to_gcs'
  ].map(t => './functional/bots/' + t)

  tests.push('./functional/lib/s3')

  opts.describeTests(tests)
}
