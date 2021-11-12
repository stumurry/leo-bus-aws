'use strict'

const MapBot = require('../bot')

class UserBot extends MapBot {
  each (payload) {
    return this.getMapper(payload.icentris_client)
      .then(mapper => {
        const promises = {}
        promises.tree_user_id = mapper.treeUserId(payload.client_user_id)
        if (payload.rank) promises.rank_id = mapper.rankId(payload.rank)
        if (payload.paid_rank) promises.paid_rank_id = mapper.rankId(payload.paid_rank)
        if (payload.type) promises.type_id = mapper.typeId(payload.type)
        if (payload.status) promises.user_status_id = mapper.userStatusId(payload.status)
        if (payload.upline && payload.upline.client_parent_id) promises.parent_id = mapper.parentId({ client_parent_id: payload.upline.client_parent_id })
        if (payload.upline && payload.upline.client_sponsor_id) promises.sponsor_id = mapper.sponsorId({ client_sponsor_id: payload.upline.client_sponsor_id })
        // if (payload.is_downline_contact !== true && payload.upline && payload.upline.client_sponsor_id) promises.contact_user_id = mapper.userId(payload.upline.client_sponsor_id)
        promises.contact_id = mapper.contactId(payload.client_user_id)
        // The intention of this call is to ensure a tree_user_plus record exists for every tree_user -- ndg 6/28/2019
        promises.tree_user_plus_id = mapper.treeUserPlusId(payload.client_user_id)
        return this.bus.Promise.props(promises)
      })
      .then(rs => {
        return Object.assign(rs, payload)
      })
  }
}

module.exports = new UserBot()
