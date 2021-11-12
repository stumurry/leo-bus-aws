'use strict'

const Bot = require('../bot')
const _ = require('lodash')

const maps = {
  period_summary_data: require('./period_summary_data')
}

class LoadExigoPeriodSummaryDataBot extends Bot {
  async handle (event, context) {
    maps.icentris_client = event.icentris_client
    return super.handle(event, context)
  }

  getTableIdTranslations () {
    return {
      PeriodVolumes: true
    }
  }

  getDomainIdColumn () {
    return 'CustomerID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      return `
      SELECT
        pv.*,
        r.RankID,
        r.RankDescription,
        pr.RankID as PaidRankID,
        pr.RankDescription as PaidRankDescription,
        p.PeriodID,
        p.PeriodDescription,
        p.StartDate,
        p.EndDate,
        t.PeriodTypeID,
        t.PeriodTypeDescription
      FROM
        PeriodVolumes pv
        INNER JOIN Ranks r on pv.RankID = r.RankID
        INNER JOIN Ranks pr on pv.PaidRankID = pr.RankID
        INNER JOIN Periods p on pv.PeriodID = p.PeriodID
        INNER JOIN PeriodTypes t on p.PeriodTypeID = t.PeriodTypeID
      WHERE
        pv.CustomerID IN (${c.ids})`
    })
  }

  transform (c) {
    const map = Object.assign(maps.period_summary_data.default, maps.period_summary_data[maps.icentris_client])
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

module.exports = new LoadExigoPeriodSummaryDataBot()
