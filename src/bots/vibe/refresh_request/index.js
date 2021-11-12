'use strict'

const Bot = require('../../bot')
const sourcesMap = require('./sources.json')

class RefreshRequest extends Bot {
  async handle (event, context) {
    this.botId = 'VibeRefreshRequest'

    if (!event.icentris_client) {
      throw new Error('Payload missing client_code!', event)
    }

    const payload = event

    if (typeof payload.event_payload !== 'object') {
      payload.event_payload = JSON.parse(payload.event_payload)
    }

    if (!sourcesMap[payload.icentris_client]) {
      throw new Error('No source defined for client!', payload)
    }

    const queue = `vibe-refresh-${sourcesMap[payload.icentris_client]}-${payload.event_type}`

    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(queue))

    stream.on('error', err => {
      console.log('stream errored', err)
    })

    stream.write(payload)

    return new Promise((resolve, reject) => {
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

module.exports = new RefreshRequest()
