'use strict'

const moment = require('moment')

const data = (level, client, message, opts = {}) => {
  opts.level = level
  opts.oid = client
  opts.msg = message

  return opts
}

class Log {
  constructor () {
    this.level = process.env.LOG_LEVEL || 4
    this.test_buffer = []
  }

  debug (client, message, opts = {}) {
    if (this.level >= 5) {
      return logwrap(data('debug', client, message, opts))
    }
  }

  error (client, message, opts = {}) {
    if (this.level >= 4) {
      return logwrap(data('error', client, message, opts))
    }
  }

  info (client, message, opts = {}) {
    return logwrap(data(client, message, opts))
  }
}

const log = new Log()

/*******************************************************************************
 * output key=values
 */

const dict2str = (data) => {
  const out = []
  for (const key in data) {
    if (data[key] instanceof Object) {
      out.push(`${key} = ${JSON.stringify(data[key])}`)
    } else {
      const str = `${data[key]}`
      // because I only want quotes if a space exists
      if (str.indexOf(' ') > -1) {
        out.push(key + '=' + JSON.stringify(str))
      } else {
        out.push(key + '=' + str)
      }
    }
  }
  return out.join(' ')
}

/*******************************************************************************
 * wrap our logs, based on dev or prod mode
 */
let logwrap
if (process.env.TEST_MODE) {
  logwrap = (data) => {
    // no timestamp for non-prod (harder to test against)
    const out = dict2str(data)
    log.test_buffer.push(out)
    return out
  }
} else {
  logwrap = (data) => {
    // timestamp isn't human readable, but this will be faster
    console.log(moment().format('YYYY-MM-DD HH:mm:ss ZZ') + ' ' + dict2str(data))
  }
}

module.exports = log
