'use strict'

const Bot = require('../../../bot')
const moment = require('moment')

class CommissionUpdatedBot extends Bot {
  async handle (event, context) {
    super.handle(event, context)

    const settings = Object.assign({
      source: 'trinity-commission-updated',
      destination: 'trinity-commissions'
    }, event)

    const stream = this.bus.leo.load(this.botId, this.bus.getQueue(settings.destination))

    return this.bus.offload(this.botId, settings.source, (payload, meta, done) => {
      payload.dealerships.map(d => {
        const commissionRun = this.commissionRunReducer(payload.commission_run)
        const dealership = this.dealershipsReducer(d)

        Object.assign(
          dealership,
          { icentris_client: payload.icentris_client, commission_run: commissionRun }
        )

        stream.write(dealership)
      })

      done(null, true)
    }).then(() => {
      return new Promise((resolve, reject) => {
        stream.end(err => {
          if (err) {
            reject(err)
          } else {
            delete this.errorStream
            resolve(null, true)
          }
        })
      })
    })
  }

  /**
    Sample Inputs:
      "dealership_id": "40309",
      "dealer_id": "43096",
      "earnings": "21.2425",
      "payable_volume": "0.0000"

    Sample Outputs:
      'dealership_id': '1234',
      'dealer_id': '2345',
      'earnings': '245.00',
      'payable_volume': '6500',
      'previous_balance': '0.00',
      'balance_forward': '50.00',
      'fee': '0.00',
      'total': '295.00',
  */
  dealershipsReducer (dealership) {
    const outObj = Object.assign({}, dealership)
    outObj.previous_balance = outObj.previous_balance || '0.00'
    outObj.balance_forward = outObj.balance_forward || '0.00'
    outObj.fee = outObj.fee || '0.00'
    outObj.total = outObj.total || outObj.earnings
    return outObj
  }

  /**
    Sample inputs:

    "commission_run": {
      "description": "Test Feb Comm",
      "run_date": "1/31/2019",
      "start_date": "1/1/2019",
      "end_date": "1/31/2019 11:59:59 PM"
    }

    Sample outputs:
    commission_run: {
        'description': 'April 2018',
        'run_date': '2018-04-01 09:00:00',
        'accepted_date': '2018-04-01 09:00:00',
        'status': {
          'id': '1',
          'description': 'Started'
        },
        'period': {
            "id": "22019",
            "description": "February 2019",
            "start_date": "1/1/2019",
            "end_date": "1/31/2019 11:59:59 PM",
            "type": {
                "id": 2,
                "description": "Monthly"
            }
        }
      }
  */
  commissionRunReducer (commissionRun) {
    const outObj = Object.assign({}, commissionRun)

    outObj.status = {
      id: '2',
      description: 'Completed'
    }

    const commissionRunId = Math.floor(Date.now() / 1000).toString()
    const runDate = moment(outObj.run_date, 'MM/DD/YYYY hh:mm:ss A')
    const [typeId, typeDescription] = this.type(outObj.start_date, outObj.end_date)
    outObj.period = {
      period_id: `${runDate.month() + 1}${runDate.year()}`,
      description: `${runDate.format('MMMM')} ${runDate.year()}`,
      start_date: outObj.start_date,
      end_date: outObj.end_date,
      type: {
        id: typeId,
        description: typeDescription
      }
    }
    return Object.assign(outObj, { id: commissionRunId, accepted_date: outObj.run_date })
  }

  /**
    Lookup table to extract the different types:
    Description      ID    No of Days:
    "Weekly":         1     7-27 days
    "Monthly":        2     28-31 days
    "Quarterly":      3     32-363 days
    "Yearly":         4     364 - 365 days for fiscal year
    "Daily":          5     1-6 days
    "YTD":            6     TBD(January 1st to date) in case request. Calculate it first before table
  */
  type (startDate, endDate) {
    const days = moment(endDate, 'MM/DD/YYYY hh:mm:ss A').diff(moment(startDate, 'MM/DD/YYYY hh:mm:ss A'), 'days')
    switch (true) {
      case days < 7:
        return ['5', 'Daily']
      case days < 28:
        return ['1', 'Weekly']
      case days < 32:
        return ['2', 'Monthly']
      case days < 364:
        return ['3', 'Quarterly']
      case days < 366:
        return ['4', 'Yearly']
      default:
        return ['7', 'Other']
    }
  }
}

module.exports = new CommissionUpdatedBot()
