const Bot = require('../../bot')
const utils = require('../../../libs/utils')
const ObjectDataMapper = require('./data_mapper.json')
const _ = require('lodash')

class TrinityLoaderBot extends Bot {
  constructor (bus) {
    super(bus)

    // Override in subclass based on attributes being processed from inQueue
    this.whiteList = []
  }

  handle (event, context) {
    if (!this.whiteList.includes('icentris_client')) {
      this.whiteList.push('icentris_client')
    }

    return this.transform(
      event.botId,
      event.source,
      event.destination,
      (payload, meta, done) => {
        this.each(payload)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null, true)
            }
          })
          .catch(err => done(err))
      })
      .then(() => this.closeAllVibeDBs())
      .catch(async (err) => {
        await this.closeAllVibeDBs()
        throw err
      })
  }

  async each (payload) {
    if (payload.icentris_client) {
      const obj = this.whiteList.reduce((objOut, keyIn) => {
        return this.payloadReducer(keyIn, payload, objOut)
      }, {})
      return obj
    } else {
      return null
    }
  }

  payloadReducer (keyIn, objIn, objOut, flatObject = false) {
    if (objIn[keyIn] === undefined && !flatObject) { return objOut }
    const customReducer = utils.snakeToCamel(keyIn) + 'Reducer' // see example clientIdReducer below

    // Let customReducer take precedence
    if (typeof this[customReducer] === 'function') {
      return this[customReducer](keyIn, objIn, objOut)
    }

    return this.standardReducer(keyIn, objIn, objOut)
  }

  standardReducer (keyIn, objIn, objOut) {
    objOut[keyIn] = objIn[keyIn]
    return objOut
  }

  // Define custom reducer functions for any key/value pair you do not want to pass through
  // as-is. Modify the objOut with the key(s)/value(s) needed, then return it.
  //
  // Example: if you want to take 'client_id' from source and make it 'consultant_id'
  // in destination, prepending the value with 'c' define:
  //
  // clientIdReducer (keyIn, objIn, objOut) {
  //   objOut['consultant_id'] = `c${value}`
  //   return objOut
  //   return { key: 'consultant_id', value: `c${value}`}
  // }

  // Shared custom reducers below. Override these as needed.
  dealerIdReducer (keyIn, objIn, objOut) {
    const dealershipId = objIn.dealership_id
    const dealerId = objIn[keyIn]

    objOut.extra = objOut.extra || {}
    objOut.extra[keyIn] = dealerId

    if (!this.isPresent(dealershipId)) {
      objOut.client_user_id = `c${objIn[keyIn]}`
    }

    return objOut
  }

  dealershipIdReducer (keyIn, objIn, objOut) {
    const dealershipId = objIn[keyIn]

    objOut.client_user_id = `d${objIn[keyIn]}`
    objOut.extra = objOut.extra || {}
    objOut.extra[keyIn] = dealershipId

    return objOut
  }

  dealerReducer (keyIn, inObj, outObj) {
    const address1 = inObj[keyIn].address1
    if (address1 !== undefined) { outObj.address = address1 }

    const dates = Object.keys(inObj[keyIn]).filter(date => /.+_date$/.test(date))
    dates.forEach(date => {
      outObj[date] = inObj[keyIn][date]
    })

    const country = inObj[keyIn].country
    if (country) this.countryReducer('country', inObj[keyIn], outObj)

    const dealerId = inObj[keyIn].dealer_id
    if (dealerId !== undefined) {
      outObj.extra = outObj.extra || {}
      outObj.extra.dealer_id = dealerId
    }

    const phoneFields = ['fax_phone', 'home_phone', 'mobile_phone']
    phoneFields.forEach((phoneField) => {
      const phone = inObj[keyIn][phoneField]
      if (phone !== undefined) {
        const phoneReducer = utils.snakeToCamel(phoneField) + 'Reducer'
        this[phoneReducer](phoneField, inObj[keyIn], outObj)
      }
    })

    this.emailReducer('email', inObj[keyIn], outObj)

    const passThruFields = [
      'first_name',
      'last_name',
      'company_name',
      'address2',
      'city',
      'state',
      'postal_code',
      'county'
    ]

    passThruFields.forEach(dealerPassThruField => {
      outObj = this.passThroughIfDefined(dealerPassThruField,
        inObj[keyIn][dealerPassThruField], outObj)
    })

    return outObj
  }

  enrollerReducer (keyIn, inObj, outObj) {
    let parentDealerId = inObj[keyIn].dealer_id
    let parentDealershipId = inObj[keyIn].dealership_id

    outObj.extra = outObj.extra || {}
    outObj.upline = outObj.upline || {}
    // Flat object check
    if (parentDealerId === undefined) {
      parentDealerId = inObj[`${keyIn}_dealer_id`]
    }
    if (parentDealerId !== undefined) {
      outObj.extra.parent_dealer_id = parentDealerId
    }
    // Flat object check
    if (parentDealershipId === undefined) {
      parentDealershipId = inObj[`${keyIn}_dealership_id`]
    }
    if (parentDealershipId !== undefined) {
      outObj.extra.parent_dealership_id = parentDealershipId
      outObj.upline.client_parent_id = `d${parentDealershipId}`
    }

    if (_.has(inObj, `${keyIn}.position`) || _.has(inObj, `${keyIn}_position`)) {
      let level = _.get(inObj, `${keyIn}.level`)
      // Flat object check
      if (!level) {
        level = _.get(inObj, `${keyIn}_parent_level`)
      }
      outObj.upline.parent_level = level
      let position = _.get(inObj, `${keyIn}.position`)
      // Flat object check
      if (position === undefined) {
        position = _.get(inObj, `${keyIn}_parent_position`)
      }
      outObj.upline.parent_position = position
    }

    return outObj
  }

  address1Reducer (keyIn, objIn, objOut) {
    const address1 = objIn.address1
    objOut.address = address1
    return objOut
  }

  genericPhoneReducer (keyIn, objIn, objOut) {
    if (process.env.NODE_ENV === 'tst') {
      objIn[keyIn] = '1111111111'
    }

    const v = objIn[keyIn]
    objOut[keyIn] = utils.removeHyphen(v)
    return objOut
  }

  faxPhoneReducer (keyIn, objIn, objOut) {
    return this.genericPhoneReducer(keyIn, objIn, objOut)
  }

  homePhoneReducer (keyIn, objIn, objOut) {
    return this.genericPhoneReducer(keyIn, objIn, objOut)
  }

  mobilePhoneReducer (keyIn, objIn, objOut) {
    return this.genericPhoneReducer(keyIn, objIn, objOut)
  }

  emailReducer (keyIn, objIn, objOut) {
    if (process.env.NODE_ENV === 'tst') {
      const emailUser = objIn[keyIn].split('@')[0]
      objIn[keyIn] = 'icentris.qa6+' + emailUser + '@gmail.com'
    }

    objOut[keyIn] = objIn[keyIn]
    return objOut
  }

  customerTypeReducer (keyIn, objIn, objOut) {
    let customerType = objIn.customer_type
    // Flat object check
    if (!customerType) {
      customerType = {
        id: objIn[`${keyIn}_id`] || '2',
        description: objIn[`${keyIn}_description`] || 'Distributor'
      }
    }
    objOut.type = customerType
    return objOut
  }

  sponsorReducer (keyIn, inObj, outObj) {
    let sponsorDealerId = inObj[keyIn].dealer_id
    // Check for flat object
    if (sponsorDealerId === undefined) {
      sponsorDealerId = inObj[`${keyIn}_dealer_id`]
    }

    outObj.extra = outObj.extra || {}
    outObj.upline = outObj.upline || {}

    if (sponsorDealerId !== undefined) {
      outObj.extra.sponsor_dealer_id = sponsorDealerId
    }

    let sponsorDealershipId = inObj[keyIn].dealership_id
    // Check for flat objects
    if (sponsorDealershipId === undefined) {
      sponsorDealershipId = inObj[`${keyIn}_dealership_id`]
    }
    if (sponsorDealershipId !== undefined) {
      outObj.upline.client_sponsor_id = `d${sponsorDealershipId}`
      outObj.extra.sponsor_dealership_id = sponsorDealershipId
    }

    if (_.has(inObj, `${keyIn}.position`) || _.has(inObj, `${keyIn}_position`)) {
      let level = _.get(inObj, `${keyIn}.level`)
      // Flat object check
      if (!level) {
        level = _.get(inObj, `${keyIn}_level`)
      }
      outObj.upline.sponsor_level = level
      let position = _.get(inObj, `${keyIn}.position`)
      // Flat object check
      if (position === undefined) {
        position = _.get(inObj, `${keyIn}_position`)
      }
      outObj.upline.sponsor_position = position
    }

    return outObj
  }

  // TODO: Expand this concept to most method using field mapping
  genericRankReducer (keyIn, objIn, objOut) {
    if (objIn[keyIn]) {
      objOut[keyIn] = {
        client_level: objIn[keyIn].id,
        name: objIn[keyIn].description
      }
    }
    return objOut
  }

  rankReducer (keyIn, objIn, objOut) {
    return this.genericRankReducer(keyIn, objIn, objOut)
  }

  paidRankReducer (keyIn, objIn, objOut) {
    return this.genericRankReducer(keyIn, objIn, objOut)
  }

  countryReducer (keyIn, objIn, objOut) {
    const country = ObjectDataMapper[keyIn][objIn[keyIn]]
    objOut[keyIn] = country || objIn[keyIn]
    return objOut
  }

  genericStatusReducer (keyIn, objIn, objOut) {
    let status = objIn[keyIn]
    // Add flat object handling
    if (!status) {
      status = {
        id: objIn[`${keyIn}_id`] || '1',
        description: objIn[`${keyIn}_description`] || 'Active'
      }
    }
    objOut[keyIn] = status
    return objOut
  }

  genericPeriodReducer (keyIn, objIn, objOut) {
    let period = objIn[keyIn]
    // Add flat object handling
    if (!period) {
      period = {
        id: objIn[`${keyIn}_id`],
        description: objIn[`${keyIn}_description`]
      }

      if (objIn[`${keyIn}_type_id`] || objIn[`${keyIn}_type_description`]) {
        period.type = {
          id: objIn[`${keyIn}_type_id`],
          description: objIn[`${keyIn}_type_description`]
        }
      }
    }
    objOut[keyIn] = period
    return objOut
  }

  statusReducer (keyIn, objIn, objOut) {
    return this.genericStatusReducer(keyIn, objIn, objOut)
  }

  periodReducer (keyIn, objIn, objOut) {
    return this.genericPeriodReducer(keyIn, objIn, objOut)
  }

  isPresent (value) {
    return (
      typeof value !== 'undefined' &&
      value !== null &&
      value !== 0 &&
      value !== ''
    )
  }

  passThroughIfDefined (key, value, outObj) {
    if (value !== undefined) { outObj[key] = value }
    return outObj
  }

  isDownlineContactReducer (keyIn, objIn, objOut) {
    objOut[keyIn] = objIn[keyIn]
    if (objOut.type && objOut.type.id === '2') {
      objOut[keyIn] = true
    }
    return objOut
  }
}

module.exports = TrinityLoaderBot
