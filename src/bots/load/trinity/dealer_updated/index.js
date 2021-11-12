'use strict'

const TrinityLoaderBot = require('../bot')

class DealerUpdatedBot extends TrinityLoaderBot {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'icentris_client',
      'dealer_id',
      'first_name',
      'last_name',
      'company_name',
      'home_phone',
      'fax_phone',
      'mobile_phone',
      'email',
      'address1',
      'address2',
      'city',
      'state',
      'postal_code',
      'county',
      'country',
      'signup_date',
      'customer_type',
      'birth_date',
      'sponsor',
      'is_downline_contact',
      'dealership_id'
    ]
  }

  payloadReducer (keyIn, objIn, objOut) {
    objIn.is_downline_contact = false
    return super.payloadReducer(keyIn, objIn, objOut)
  }

  async handle (event, context) {
    this.botId = event.botId

    const settings = Object.assign({
      source: 'trinity-dealer-updated',
      destination: 'new-users'
    }, event)

    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(settings.destination))

    return this.bus.offload(this.botId, settings.source, (payload, meta, done) => {
      if (payload.dealership_ids && Array.isArray(payload.dealership_ids)) {
        // 'dealership_ids[]' is present, we need to offload 1 event per array item
        payload.dealership_ids.map(dealershipId => {
          const dealershipPayload = this.whiteList.reduce((objOut, keyIn) => {
            // Enrich the payload with some dealership fields
            return this.payloadReducer(keyIn, Object.assign({ dealership_id: dealershipId }, payload, { customer_type: { id: 2, description: 'Distributor' } }), objOut)
          }, {})

          stream.write(dealershipPayload)
        })
      } else {
        const reducedPayload = this.whiteList.reduce((objOut, keyIn) => {
          return this.payloadReducer(keyIn, payload, objOut)
        }, {})

        stream.write(reducedPayload)
      }

      done(null, true)
    }).then(() => {
      return new Promise((resolve, reject) => {
        stream.end(err => {
          if (err) {
            reject(err)
          } else {
            delete this.errorStream
            resolve(null, true)
          }
        })
      })
    })
  }
}

module.exports = new DealerUpdatedBot()
