'use strict'

const TreeBot = require('../bot')

class TreePlacementsBot extends TreeBot {
  constructor (bus) {
    super(bus)
    this.type = 'placement'
  }
}

module.exports = new TreePlacementsBot()
