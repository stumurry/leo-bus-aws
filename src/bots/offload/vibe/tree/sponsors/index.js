'use strict'
'use strict'

const TreeBot = require('../bot')

class TreeSponsorsBot extends TreeBot {
  constructor (bus) {
    super(bus)
    this.type = 'sponsor'
  }
}

module.exports = new TreeSponsorsBot()
