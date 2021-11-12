'use strict'

const assert = require('assert')
const request = require('superagent')
const jwt = require('jsonwebtoken')
const uuid4 = require('uuid/v4')
const base64 = require('base-64')
const mysql = require('mysql2/promise')

const reflex = new (require('rfxcfg/reflex')).Session({
  REFLEX_URL: process.env.REFLEX_URL,
  REFLEX_APIKEY: process.env.REFLEX_APIKEY
})

const eventType = 'CUSTOMER_ENROLLMENT'
const customerEnrollmentData = {
  _event: 'CUSTOMER_ENROLLMENT',
  dealer_id: '814160',
  first_name: 'Test',
  last_name: 'Tustomer',
  company_name: '',
  home_phone: '',
  fax_phone: '',
  mobile_phone: '',
  email: 'Info@nevetica.com',
  address1: '',
  address2: '',
  city: '',
  state: 'TX',
  postal_code: '',
  county: '',
  country: 'USA',
  signup_date: '8/6/2018 7:54:46 AM',
  customer_type: {
    id: '1',
    description: 'Retail Customer'
  },
  birth_date: '',
  sponsor: {
    dealership_id: '787991',
    dealer_id: '814158'
  }
}

process.env.NODE_TLS_REJECT_UNAUTHORIZED = 0

describe('nevetica-customer-enrollment', () => {
  describe('databus-ingress#post', () => {
    let config
    before(async () => {
      console.log(reflex)
      config = await reflex.getConfig('databus-ingress-d1').then(cfg => cfg)
      console.log(config)
    })

    it.only('testing', () => {
      console.log('done')
    })

    let accessToken
    it('should fetch the access token', async function () {
      const refreshToken = jwt.sign({
        jti: uuid4(),
        sub: config.nevetica.domain,
        kid: config.nevetica.key
      }, base64.decode(config.nevetica.secret), {
        expiresIn: 15 * 60
      })

      accessToken = await request.post(`${config.nevetica.domain}/auth/v0/access`)
        .set('Content-Type', 'application/json')
        .redirects(0)
        .send({
          client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
          client_assertion: refreshToken
        })
        .catch(err => {
          if (err.message === 'Found') {
            return JSON.parse(err.response.res.text).access_token
          } else {
            throw err
          }
        })

      assert(accessToken)
    })

    it('should successfully post the CUSTOMER_ENROLLMENT event', async function () {
      const rs = await request.post(`${config.nevetica.domain}/data/v1/event/${eventType}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send(customerEnrollmentData)

      assert(rs.statusCode === 204)
    })
  })

  describe('vibe-db#verify', () => {
    let conn
    let tnl
    before(async () => {
      const mysqlConfig = await reflex.getConfig('leo-bus-d1').then(cfg => cfg.sensitive.config.tenant.nevetica.vibe.mysql)
      if (process.env.NODE_ENV === 'local') {
        const tunnel = require('tunnel-ssh')
        const tunnelConfig = {
          username: 'ngoodrich',
          host: 'gateway.dev.vibeoffice.com',
          privateKey: require('fs').readFileSync('/root/.ssh/id_rsa'),
          passphrase: '#lisabeth is an amazing wife!',
          dstHost: mysqlConfig.host,
          dstPort: 3306,
          localPort: 3306,
          localHost: '127.0.0.1'
        }

        mysqlConfig.host = '127.0.0.1'

        tnl = await new Promise((resolve, reject) => {
          tunnel(tunnelConfig, (err, server) => {
            if (err) reject(err)
            else resolve(server)
          })
        })
      }

      try {
        conn = await mysql.createConnection(mysqlConfig)
      } catch (err) {
        console.log('failed to create mysql connection')
        console.log(err)
      }

      await conn.execute('DELETE FROM tree_users')
      await conn.execute('ALTER TABLE tree_users AUTO_INCREMENT=1')
    })

    after(async () => {
      await conn.end()
      await tnl.close
    })

    it.skip('testing reflex', () => {
      console.log('done')
    })
    it('should reflect the new customer enrollment in the nevetica tree_users table', async function () {
      this.timeout(60000)

      const getTreeUser = async (ticker = 6) => {
        if (!ticker) {
          return null
        }
        const ms = ticker === 6 ? 0 : 500
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            resolve()
          }, ms)
        }).then(() => {
          return conn.execute('SELECT * FROM tree_users WHERE client_user_id = ?', [customerEnrollmentData.dealer_id])
            .then(rs => {
              rs = rs[0]

              if (rs.length === 0) {
                return getTreeUser(--ticker)
              } else {
                return rs[0]
              }
            })
        })
      }

      const treeUser = await getTreeUser()

      assert.notStrictEqual(treeUser, null)
    })
  })
})
