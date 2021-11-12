'use strict'

const Bot = require('../bot')
const _maps = {}

class LoadExigoTreeNodeBot extends Bot {
  async handle (event, context) {
    this._initMap(event)
    return super.handle(event, context)
  }

  _initMap (event) {
    const settings = { ...event }
    _maps.icentris_client = settings.icentris_client
    _maps.table = settings.table
    _maps.fields = settings.fields
  }

  getTableIdTranslations () {
    const table = _maps.table
    return {
      [table]: true
    }
  }

  getDomainIdColumn () {
    return 'CustomerID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      return `
      select
        ${_maps.fields}
      from
        ${_maps.table}
      where
        CustomerID IN (${c.ids})`
    })
  }

  transform (c) {
    let type, upline, position
    if (_maps.table === 'UniLevelTree') {
      type = 'placements'
      upline = c.SponsorID
      position = c.Placement
    } else {
      type = 'sponsors'
      upline = c.EnrollerID
      // Note: Figure out how to calculate this for sponsor if requested
      position = 0
    }
    return {
      client_user_id: c.CustomerID,
      type,
      client_upline_id: upline,
      level: c.NestedLevel,
      position: position,
      lft: c.Lft,
      rgt: c.Rgt
    }
  }
}

module.exports = new LoadExigoTreeNodeBot()
