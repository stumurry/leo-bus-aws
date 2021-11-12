'use strict'

const Bot = require('../bot')

class LoadExigoCommissionsBot extends Bot {
  getTableIdTranslations () {
    return {
      Commissions: ['CommissionRunID', 'CustomerID']
    }
  }

  getDomainIdColumn () {
    return ['CommissionRunID', 'CustomerID']
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      // https://github.com/iCentris/leo-bus/wiki/Commission

      /**
       * @author s murry
       * @date 5/23/2019
       * @summary `IN` Statements vary from database for composite keys.
       * c.ids => [ [2836,1], [2836,2] ]
       * For SQLServer => WHERE (CustomerID=2 AND CommissionRunID=2836) OR (CustomerID=1 AND CommissionRunID=2836) // ?? Double Check.  Maybe a better way.
       * For Mysql => WHERE (CustomerID, CustomerRunID) IN ((2,2836), (1,2386))
       */
      const inClause = c.ids.map(s => `(c.CommissionRunID=${s[0]} AND c.CustomerID=${s[1]})`)

      const q = `select * from Commissions c
      join CommissionRuns cr on cr.CommissionRunID = c.CommissionRunID
      join CommissionRunStatuses crs on crs.CommissionRunStatusID = cr.CommissionRunStatusID
      join Periods p on p.PeriodID = cr.PeriodID
      join PeriodTypes pt on pt.PeriodTypeID = p.PeriodTypeID
      
      WHERE ${inClause.join(' OR ')}`
      return q
    }).hasMany('commission_bonuses', c => {
      // composite keys
      const inClause = c.ids.map(s => `(cb.CommissionRunID=${s[0]} AND cb.CustomerID=${s[1]})`)
      return `select * from CommissionBonuses cb
      join Bonuses b on b.BonusID = cb.BonusID
      WHERE ${inClause.join(' OR ')}`
    }, ['CommissionRunID', 'CustomerID'], c => {
      return {
        bonus: {
          id: c.BonusID,
          description: c.BonusDescription
        },
        amount: c.Amount
      }
    })
  }

  transform (c) {
    return {
      client_user_id: c.CustomerID,
      total: c.Total,
      earnings: c.Earnings,
      balance_forward: c.BalanceForward,
      previous_balance: c.PreviousBalance,
      fee: c.Fee,
      commission_run: {
        id: c.CommissionRunID,
        description: c.CommissionRunDescription,
        run_date: c.RunDate,
        accepted_date: c.AcceptedDate,
        status: {
          id: c.CommissionRunStatusID,
          description: c.CommissionRunStatusDescription
        },
        period: {
          client_period_id: c.PeriodID,
          description: c.PeriodDescription,
          start_date: c.StartDate,
          end_date: c.EndDate,
          type: {
            id: c.PeriodTypeID,
            description: c.PeriodTypeDescription
          }
        }
      }
    }
  }
}

module.exports = new LoadExigoCommissionsBot()
