'use strict'

const Bot = require('../bot')

class LoadExigoSubscriptionBot extends Bot {
  getTableIdTranslations () {
    return {
      CustomerSubscriptions: true
    }
  }

  getDomainIdColumn () {
    return 'CustomerID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      return `
      select
        cs.CustomerID,
        cs.StartDate,
        cs.ExpireDate,
        cs.IsActive,
        s.SubscriptionID,
        s.SubscriptionDescription
      from
        CustomerSubscriptions as cs
        inner join Subscriptions s on cs.SubscriptionID = s.SubscriptionID
      where
        cs.IsActive = 1
        and cs.CustomerID IN (${c.ids})`
    })
  }

  transform (c) {
    return {
      client_user_id: c.CustomerID,
      start_date: c.StartDate,
      expire_date: c.ExpireDate,
      active: c.IsActive,
      subscription_plan: {
        id: c.SubscriptionID,
        name: c.SubscriptionDescription
      }
    }
  }
}

module.exports = new LoadExigoSubscriptionBot()
