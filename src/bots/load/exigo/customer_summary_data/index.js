'use strict'

const Bot = require('../bot')
const _ = require('lodash')
const maps = {
  customer_summary_data: require('./customer_summary_data.json')
}

class LoadExigoCustomerSummaryDataBot extends Bot {
  async handle (event, context) {
    maps.icentris_client = event.icentris_client
    return super.handle(event, context)
  }

  getTableIdTranslations () {
    return {
      Customers: true
    }
  }

  getDomainIdColumn () {
    return 'CustomerID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      return `
      select
        CustomerID, Field1, Field2, Field3, Field4, Field5,
        Field6, Field7, Field8, Field9, Field10, Field11,
        Field12, Field13, Field14, Field15
      from
        Customers
      where
        CustomerID IN (${c.ids})`
    })
  }

  transform (c) {
    const map = Object.assign(maps.customer_summary_data.default, maps.customer_summary_data[maps.icentris_client])
    const domainObj = {}

    _.forOwn(map, (payloadField, domainField) => {
      if (_.has(c, payloadField)) {
        _.set(domainObj, domainField, _.get(c, payloadField))
      } else {
        _.set(domainObj, domainField, null)
      }
    })

    return domainObj
  }
}
module.exports = new LoadExigoCustomerSummaryDataBot()
