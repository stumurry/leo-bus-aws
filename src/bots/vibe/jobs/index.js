'use strict'

const Bot = require('../../bot')
const request = require('superagent')

class VibeJobsBot extends Bot {
  constructor (bus) {
    super(bus)

    this.jobs = [
      'update_usertypes.json']
  }

  async handle (event, context) {
    const tenants = await this.getTenantConfigs()
    const jobs = []
    Object.keys(tenants).map(t => {
      return this.jobs.map(j => {
        jobs.push({ client: t, job: j })
      })
    })

    return this.bus.Promise.map(jobs, obj => {
      return this.getRequest(obj.client, obj.job)
        .then(res => {
          return Object.assign(obj, res.body)
        })
    }, { concurrency: 5 })
  }

  async getRequest (client, job) {
    const { api, url } = await this.getConfig(client).then(cfg => cfg.vibe)
    return request.get(`${url}/api/v1/${job}`).set('USER-NAME', 'emailauto').set('AUTH-TOKEN', api.bearer_token).type('application/json')
  }
}

module.exports = new VibeJobsBot()
