
'use strict'

const VibeOffloadBot = require('../bot')
class TreeNodeBot extends VibeOffloadBot {
  async each (payload, meta) {
    if ([null, '', 0, undefined].indexOf(payload.tree_user_id) > -1) {
      throw new Error(`payload.tree_user_id has an invalid value: '${payload.tree_user_id}'`)
    }

    const table = payload.type === 'placements' ? 'tree_placements' : 'tree_sponsors'
    const str = await this.getTableWriteStream(payload.icentris_client, table)
    str.write({
      record: {
        tree_user_id: payload.tree_user_id,
        upline_id: payload.upline_id,
        lft: payload.lft,
        rgt: payload.rgt,
        level: payload.level,
        position: payload.position
      },
      eid: meta.eid
    })
  }
}

module.exports = new TreeNodeBot()
