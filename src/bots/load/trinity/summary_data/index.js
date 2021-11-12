'use strict'

const TrinityLoader = require('../bot')
const TrinitySummaryData = require('../../../../libs/models/bots/load/trinity/summary_data/summary_data')
const utils = require('../../../../libs/utils')
// TODO: Merged these two
const summaryData = require('./summary_data.json')
const fieldMapper = require('./field_mapper.json')

class SummaryDataBot extends TrinityLoader {
  constructor (bus) {
    super(bus)

    this.whiteList = [
      'icentris_client',
      'dealership_id',
      'dealer_id',
      'rank',
      'paid_rank',
      'period',
      'personal_volume',
      'group_volume',
      'allowed_volume',
      'personally_sponsored_rankholders'
    ]
  }

  handle (event, context) {
    if (!this.whiteList.includes('icentris_client')) {
      this.whiteList.push('icentris_client')
    }
    const each = (payload, meta, done) => {
      const payloadSnaked = utils.objectCamelToSnake(payload)
      if (payloadSnaked.icentris_client) {
        /*
          There are 4 classifications for summary_data payload fields
          1) White-listed:
            - Defined in this.whiteList
            - Passed through reducers for formatting and (possibly) renaming
          2) Mapped:
            - Defined in ./summary_data.json
            - Maps payload fields to domainObj fields
          3) Extra:
            - Anything not white-listed or mapped will be placed in 'extra'.
              If you need an exception to keep a mapped field in extra, then add it to mappedFieldInExtra
              in summary_data.json
          4) Default:
            - Defined in TrinitySummaryData class
            - Add any fields that are missing
          jc 10/4/2018
        */

        // White-listed fields
        let domainObj = this.whiteList.reduce((objOut, keyIn) => {
          return this.payloadReducer(keyIn, payloadSnaked, objOut, true)
        }, {})

        // Mapped fields
        domainObj = this.mapFields(payloadSnaked, domainObj)

        // Extra fields
        domainObj.extra = domainObj.extra || {}
        // are the rank in psranks or in extra ? double check that?
        Object.keys(payloadSnaked)
          .filter(k => !this.includesKey(k, payloadSnaked))
          .forEach(k => {
            domainObj.extra[k] = payloadSnaked[k]
          })

        // check if any additional field needs to be placed in extra
        summaryData.mappedFieldInExtra.forEach(k => {
          if (k in domainObj) {
            domainObj.extra[k] = domainObj[k]
            delete domainObj[k]
          }
        })

        // Default fields
        domainObj = Object.assign(new TrinitySummaryData(), domainObj)

        done(null, domainObj)
      } else {
        done()
      }
    }

    return this.transform(
      event.botId,
      event.source,
      event.destination,
      each
    )
  }

  includesKey (payloadKey, payloadSnaked) {
    let check = this.whiteList.includes(payloadKey)
    if (!check) {
      this.whiteList.forEach(key => {
        if (payloadKey.startsWith(`${key}_`)) {
          check = true
        }
      })
    }
    return check
  }

  // TODO: Expand this concept to most method using field mapping
  genericRankReducer (keyIn, objIn, objOut) {
    const rankFields = fieldMapper[keyIn][objIn.icentris_client]
    // Flat objects
    const outRank = Object.entries(rankFields).reduce((ranks, rank) => {
      // Default behaviour EX: rank: {id: 1, description: 'blah'}
      if (objIn[keyIn]) {
        ranks[rank[0]] = objIn[keyIn][rank[1]]
      } else if (objIn[rank[1]]) { // Flat objects rank_id
        ranks[rank[0]] = objIn[rank[1]]
        delete objIn[rank[1]]
      } else if (objIn[`${keyIn}_${rank[1]}`]) { // Custom Flat objects curr_month_lifetime_rank
        ranks[rank[0]] = objIn[`${keyIn}_${rank[1]}`]
        delete objIn[rank[1]]
      }
      return ranks
    }, {})
    objOut[keyIn] = outRank
    return objOut
  }

  genericPeriodReducer (keyIn, objIn, objOut) {
    const output = super.genericPeriodReducer(keyIn, objIn, objOut)
    const periodTypes = Object.assign(summaryData[`${keyIn}type`].default, summaryData[`${keyIn}type`][objIn.icentris_client])

    if (objIn[`${keyIn}_start_date`]) {
      output[keyIn].start_date = objIn[`${keyIn}_start_date`]
    }

    if (objIn[`${keyIn}_end_date`]) {
      output[keyIn].end_date = objIn[`${keyIn}_end_date`]
    }

    if (objIn[`${keyIn}_type`]) { // Trinity latest field change PeriodType and (PeriodTypeID missing)
      const description = objIn[`${keyIn}_type`]
      output[`${keyIn}`].type = {
        id: periodTypes[`${description.toLowerCase()}`],
        description
      }
    }
    return output
  }

  personallySponsoredRankholdersReducer (keyIn, objIn, objOut) {
    return this.genericRankReducer(keyIn, objIn, objOut)
  }

  mapFields (payload, domainObj) {
    const mappedFields = Object.assign(summaryData.mapping.default, summaryData.mapping[payload.icentris_client])
    Object.entries(mappedFields)
      .forEach((kv) => {
        domainObj[kv[0]] = payload[kv[1]]
        delete payload[kv[1]]
      })
    return domainObj
  }
}
module.exports = new SummaryDataBot()
