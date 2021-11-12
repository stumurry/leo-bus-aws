'use strict'

const Bus = require('../libs/bus')
const mysql = require('../libs/mysql')
const _ = require('lodash')
const AWS = require('aws-sdk')
const kms = new AWS.KMS({ region: 'us-west-2' })
const fernet = require('fernet')
const request = require('superagent')

class Bot {
  constructor (bus) {
    this.bus = bus || new Bus()
    this.clients = {}
    this.handler = this.handler.bind(this)
  }

  handler (event, context, callback) {
    this.handle(event, context)
      .then(rs => callback(null, rs))
      .catch(err => callback(err))
  }

  async getBinaryContents (url, privateToken, numberOfRetry) {
    const bearer = `Basic ${privateToken.trim()}`
    return new Promise((resolve, reject) => {
      let attempts = 0
      const requestRetry = (url, n) => {
        return request
          .get(url)
          .set('Authorization', bearer)
          .buffer(true)
          .parse((res, callback) => {
            res.setEncoding('binary')
            res.data = ''
            res.on('data', function (chunk) {
              res.data += chunk
            })
            res.on('end', function () {
              callback(null, Buffer.from(res.data, 'binary'))
            })
          })
          .then(rs => {
            const status = rs.status
            if (status === 200) {
              return resolve(rs.body)
            } else if (n === 1) {
              throw reject(new Error('Request Error Retrying'))
            } else {
              console.log('Retry again: Got back status ::' + status)
              setTimeout(() => {
                requestRetry(url, n - 1)
              }, Math.pow(2, attempts++) * 1000)
            }
          }).catch(function (error) {
            if (n === 1) {
              reject(error)
            } else {
              setTimeout(() => {
                requestRetry(url, n - 1)
              }, Math.pow(2, attempts++) * 1000)
            }
          })
      }
      return requestRetry(url, numberOfRetry)
    })
  }

  async getRemoteConfig () {
    if (!this.config) {
      try {
        const gitToken = await kms.decrypt({ CiphertextBlob: Buffer.from(process.env.GIT_SECRET, 'base64') })
          .promise()
          .then(secret => {
            const token = Buffer.from(`icentrisdtm:${secret.Plaintext.toString()}`)
            return token.toString('base64')
          })

        const cfg = await Promise.all([
          this.getBinaryContents(`${process.env.GIT_URL}/${process.env.NODE_ENV}/dek.enc`, gitToken, 5),
          this.getBinaryContents(`${process.env.GIT_URL}/${process.env.NODE_ENV}/config.enc`, gitToken, 5)
        ])
          .then(([dekResp, configResp]) => {
            const dekObj = JSON.parse(dekResp.toString())
            const configObj = JSON.parse(configResp.toString())
            return [Buffer.from(dekObj.content.trim(), 'base64'), Buffer.from(configObj.content.trim(), 'base64')]
          })
          .then(([dek, config]) => {
            return Promise.all([
              kms.decrypt({ CiphertextBlob: dek })
                .promise()
                .then(rs => {
                  return Buffer.from(rs.Plaintext)
                }),
              Promise.resolve(config)
            ])
          })
          .then(([key, config]) => {
            const secret = new fernet.Secret(key.toString('utf8'))
            const token = new fernet.Token({
              secret: secret,
              token: config.toString('utf8'),
              ttl: 0
            })
            token.decode()
            return JSON.parse(token.message)
          })

        if (!cfg || !_.has(cfg, 'sensitive.bus')) {
          throw new Error('config is invalid!')
        }

        this.config = cfg.sensitive
      } catch (err) {
        err.message = 'Failed to load config with error: ' + err.message
        throw err
      }
    }

    return this.config
  }

  async getTenantConfigs () {
    if (!this.tenantConfigs) {
      const cfg = await this.getRemoteConfig()
      if (!_.has(cfg, 'bus.tenant')) {
        throw new Error('missing tenants from config!')
      }

      this.tenantConfigs = _.get(cfg, 'bus.tenant')
    }

    return this.tenantConfigs
  }

  async getConfig (client) {
    if (!this.clients[client]) {
      this.clients[client] = {}
    }

    if (!this.clients[client].config) {
      const config = await this.getTenantConfigs()
      if (!Object.keys(config).includes(client)) {
        throw new Error(`missing tenant config for client ${client}!`)
      }

      this.clients[client].config = config[client]
    }

    return _.get(this.clients, `${client}.config`)
  }

  async getVibeDB (client) {
    if (!this.clients[client] || !this.clients[client].vibeDB) {
      const config = await this.getConfig(client).then(fig => fig.vibe.mysql)
      config.bus = this.bus
      this.clients[client].vibeDB = await mysql(config)
    }

    return this.clients[client].vibeDB
  }

  closeVibeDB (client) {
    if (this.clients[client].vibeDB) {
      return this.clients[client].vibeDB.end().then(() => {
        delete this.clients[client].vibeDB
      })
    }

    return this.bus.Promise.resolve()
  }

  closeAllVibeDBs () {
    return Promise.all(Object.keys(this.clients).map(c => {
      return this.closeVibeDB(c)
    }))
  }

  getErrorStream () {
    return this.bus.getErrorStream(this.botId)
  }

  async endErrorStream () {
    return this.bus.endErrorStream()
  }

  each (payload) {
    throw new Error('Must be implemented by the individual bots!')
  }

  async handle (event, context) {
    this.botId = event.botId || context.botId
    this.event = event
  }

  transform (botId, source, destination, each, config = {}) {
    const leo = this.bus.leo
    const ls = leo.streams
    const stats = ls.stats(botId, source)

    return new Promise((resolve, reject) => {
      ls.pipe(ls.fromLeo(botId, source),
        stats,
        ls.through((obj, done) => {
          each(obj.payload, {}, done)
        }),
        leo.load(botId, destination),
        err => {
          if (err) {
            reject(err)
          } else {
            stats.checkpoint(resolve)
          }
        })
    }).then(() => {
      // console.log('closing db connection')
      return this.closeAllVibeDBs()
    }).then(() => {
      this.mappers = {}
    }).catch(async err => {
      await this.closeAllVibeDBs()
      throw err
    })
  }

  // closeConnection() is overridden by unit test. The unit test will cache the connection instead of closing it.
  // closing it at the end of the test instead of at the end of the domain loader call.
  closeConnection (client, err, resolve, reject, stats) {
    if (client) {
      client.end((e) => {
        if (err || e) {
          reject(err || e)
        } else {
          stats.checkpoint(resolve)
        }
      })
    } else {
      if (err) {
        reject(err)
      } else {
        stats.checkpoint(resolve)
      }
    }
  }
}

module.exports = Bot
