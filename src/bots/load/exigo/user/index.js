'use strict'

const Bot = require('../bot')

class LoadExigoUserBot extends Bot {
  getTableIdTranslations () {
    return {
      Customers: true,
      CustomerSites: true,
      CustomerAccounts: true,
      CustomerSubscriptions: true
    }
  }

  getDomainIdColumn () {
    return 'CustomerID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      return `
            select c.*, cs.WebAlias, ut.NestedLevel, ut.Placement, ct.CustomerTypeID, ct.CustomerTypeDescription, 
            /* a.SubscriptionID as SubscriptionSubscriptionID, a.CustomerID as SubscriptionCustomerID, */
            r.RankID, r.RankDescription, 
            css.CustomerStatusID, css.CustomerStatusDescription,
            d.CodedDate
            
            from customers c

            /* 
                left outer join (select max(SubscriptionID) as SubscriptionID, CustomerID 
                from CustomerSubscriptions 
                where SubscriptionID < 3 and IsActive = 1 and ExpireDate > GETDATE() 
                group by CustomerID) as a on a.CustomerID = c.CustomerID 
            */

            left outer join customersites cs on cs.CustomerID = c.CustomerID
            left outer join unileveltree ut on ut.CustomerID = c.CustomerID
            left outer join customertypes ct on ct.CustomerTypeID = c.CustomerTypeID
            left outer join codedranks d ON c.CustomerID = d.CustomerID AND d.CodingTypeID = 1

            left outer join ranks r ON r.RankID = c.RankID
            left outer join customerstatuses css ON css.CustomerStatusID = c.CustomerStatusID
                
            WHERE c.CustomerID IN (${c.ids})
        `
    })
  }

  transform (c) {
    return {
      extra: {
        // Trinity Specific
        // "dealer_id": "",
        // "sponsor_dealer_id": "",
        // "sponsor_dealership_id": "",
        // 'subscription_id': c.SubscriptionSubscriptionID, // Charles
        web_alias: c.WebAlias // Charles
      },

      client_user_id: c.CustomerID,
      first_name: c.FirstName,
      last_name: c.LastName,
      email: c.Email,
      home_phone: c.Phone,
      mobile_phone: c.MobilePhone,
      fax_phone: c.Fax,
      address: c.MainAddress1,
      address2: c.MainAddress2,
      city: c.MainCity,
      state: c.MainState,
      postal_code: c.MainZip,
      county: c.MainCounty,
      country: c.MainCountry,
      mail_address: c.MailAddress1,
      mail_address2: c.MailAddress2,
      mail_city: c.MailCity,
      mail_state: c.MailState,
      mail_postal_code: c.MailZip,
      mail_county: c.MailCounty,
      mail_country: c.MailCountry,
      signup_date: c.CreatedDate,
      birth_date: c.BirthDate,
      company_name: c.Company,
      rank: {
        client_level: c.RankID,
        name: c.RankDescription
      },
      status: {
        id: c.CustomerStatusID,
        description: c.CustomerStatusDescription
      },
      type: {
        id: c.CustomerTypeID,
        description: c.CustomerTypeDescription
      },
      upline: {
        client_sponsor_id: c.EnrollerID,
        client_parent_id: c.SponsorID
        // 'sponsor_level': c.NestedLevel,
        // 'sponsor_position': c.Placement
      },
      is_downline_contact: false
    }
  }
}

module.exports = new LoadExigoUserBot()
