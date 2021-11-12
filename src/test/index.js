'use strict'

const sinon = require('sinon')
const Bus = require('../libs/bus')
const fs = require('fs')
const path = require('path')
const fileUtils = require('../utils/file_utils')

const opts = {
  moment: require('moment'),
  assert: require('assert'),
  sinon: sinon,
  nock: require('nock'),
  maxTime: 2000,
  event: {
    botId: 'event-botId',
    source: 'test-source',
    destination: 'test-destination'
  },
  context: {
    botId: 'context-botId',
    getRemainingTimeInMillis: () => {
      const timeSpent = new Date() - opts.start
      if (timeSpent < opts.maxTime) {
        return opts.maxTime - timeSpent
      } else {
        return 0
      }
    }
  },
  callback: function (err, data) {
    throw err
  },
  describeTests: (tests) => {
    tests.map(path => {
      describe(path, () => {
        require(path)(opts)
      })
    })
  }
}

describe('Test Suite', () => {
  before(async function () {
    this.timeout(5000)
    try {
      /**
       * Bootstrap the config into leo
       */
      require('leo-config').bootstrap(require('../leo_config.js'))
      opts.mysql = await require('../libs/mysql')(require('./config.json').bus.tenant.bluesun.vibe.mysql)
      opts.mssql = await require('../libs/mssql')(require('./config.json').bus.tenant.idlife.exigo)

      opts.bus = new Bus()
      opts.mysql.bus = opts.bus
      opts.mssql.bus = opts.bus // Don't know why the bus is part of the mysql datasource?

      /* @author m ewell
      * @since 7/24/2018
      * @summary Kill a table's rows without killing the whole table
      * @description
      *   Using SQL 'TRUNCATE' drops the table and re-creates, which leads to
      * constraint violations if foreign keys are defined. Removing the rows
      * instead of dropping the table solves this.
      */
      opts.mysql.truncate = async (table) => {
        await opts.mysql.execute(`DELETE FROM ${table}`)
        await opts.mysql.execute(`ALTER TABLE ${table} AUTO_INCREMENT = 1`)
      }
    } catch (err) {
      console.log('caught err ' + err)
    }
  })

  after(() => {
    opts.mssql.end()
    // end all stored unit test's cached connections
    opts.mssql.connections.forEach(c => c.end())

    return opts.mysql.end()
  })

  describe('Integration Tests', () => {
    require('./integration/index')(opts)
  })

  describe('Functional Tests', () => {
    require('./functional/index')(opts)
  })

  describe('Bots - package.json', () => {
    const assert = opts.assert
    let files = []
    it('should be a valid JSON file', async () => {
      const results = await fileUtils.getFiles('bots')
      const packages = results.filter(s => path.basename(s) === 'package.json' ||
                      path.basename(s) === 'package.deprecated.json')
      const failures = []
      files = packages.map(s => {
        try {
          const o = JSON.parse(fs.readFileSync(s))
          return { file: s, name: o.name }
        } catch (err) {
          failures.push(s)
        }
      })

      if (failures.length > 0) {
        assert.fail(`The following files failed to parse ${console.log(failures)}`)
      }
    })

    it('should not contain duplicate bot names', async () => {
      const names = {}
      files.forEach(o => {
        if (!names[o.name]) {
          names[o.name] = { count: 0, files: [] }
        }

        names[o.name].count++
        names[o.name].files.push(o.file)
      })

      const failures = []
      Object.keys(names).forEach(o => {
        if (names[o].count > 1) {
          failures.push(names[o])
        }
      })

      if (failures.length > 0) {
        assert.fail(`The following names were duplicated ${JSON.stringify(failures)}`)
      }
    })
  })
})
