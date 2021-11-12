'use strict'
const _timezones = require('./../../../../../bots/plmb/utc_transform/timezones')
const moment = require('moment')

// Clients assumed timezones so far
// "bluesun": "CDT"
// "idlife": "CDT",
// "nevetica": "MDT", UTC-7
// "stampinup": "MDT"

// utc offsets
// EDT Offset: UTC -4
// CDT Offset: UTC -5
// CST Offset: UTC -6
// MDT Offset: UTC -6
// PDT Offset: UTC -7
// Expected datetime format in the Vibe database ex: DATETIME - format: YYYY-MM-DD HH:MI:SS
module.exports = (opts) => {
  const UTCTransformer = require('../../../../../bots/plmb/utc_transform/bot')
  const assert = opts.assert
  let bot

  beforeEach(async () => {
    // Override getTimezone
    class DerivedUTC extends UTCTransformer {
      getTimezone (client) {
        // supported timezone so far: MDT and CDT
        // need to test EDT, PDT and others
        _timezones.clientEDT = 'EDT'
        _timezones.clientPDT = 'PDT'
        _timezones.clientCST = 'CST'
        return _timezones[client]
      }
    }
    bot = new DerivedUTC(opts.bus)
  })

  describe('#utc transform handle', function () {
    it('Handles any valid date format, even if it does not match formatIn', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '9/1/2018 5:09:41 AM'
      }, {
        icentris_client: 'nevetica',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '12/12/2017 12:09:41 PM'
      }]

      const formatOut = 'YYYY-MM-DD HH:mm:ss'
      const zone0 = _timezones[opts.bus.inQueueData[0].icentris_client]
      const zone1 = _timezones[opts.bus.inQueueData[1].icentris_client]

      const date0 = '1/1/1970'
      const date1 = '1970-01-01'
      Object.assign(opts.bus.inQueueData[0], { signup_date: date0 })
      Object.assign(opts.bus.inQueueData[1], { signup_date: date1 })

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload
      const outDate0 = moment(new Date(`${date0} ${zone0}`)).format(formatOut)
      const outDate1 = moment(new Date(`${date1} ${zone1}`)).format(formatOut)

      assert.strictEqual(outDate0, out0.signup_date)
      assert.strictEqual(outDate1, out1.signup_date)
    })

    it('Handles nested dates', async () => {
      opts.bus.inQueueData = [{
        dealership_id: '1234',
        dealer_id: '2345',
        earnings: '245.00',
        payable_volume: '6500',
        bonuses: [{
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00',
          a_date: '1/31/2019 11:59:59 PM'
        }, {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00',
          b_date: '1/31/2019 11:59:59 PM'
        }],
        previous_balance: '0.00',
        balance_forward: '0.00',
        fee: '0.00',
        total: '245.00',
        icentris_client: 'nevetica',
        commission_run: {
          accepted_date: '1/31/2019',
          description: 'Test Feb Comm',
          run_date: '1/31/2019',
          start_date: '1/1/2019',
          end_date: '1/31/2019 11:59:59 PM',
          status: {
            id: '2',
            description: 'Completed'
          },
          period: {
            period_id: '12019',
            description: 'January 2019',
            start_date: '1/1/2019',
            end_date: '1/31/2019 11:59:59 PM',
            type: {
              description: 'Monthly',
              id: '2'
            }
          }
        },
        id: '1562967231'
      }]

      const expectedOutput = {
        icentris_client: 'nevetica',
        dealership_id: '1234',
        dealer_id: '2345',
        earnings: '245.00',
        payable_volume: '6500',
        bonuses: [{
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00',
          a_date: '2019-02-01 05:59:59'
        }, {
          bonus_type: {
            id: '1',
            description: 'Retail Bonus'
          },
          amount: '130.00',
          b_date: '2019-02-01 05:59:59'
        }],
        previous_balance: '0.00',
        balance_forward: '0.00',
        fee: '0.00',
        total: '245.00',
        commission_run: {
          accepted_date: '2019-01-31 06:00:00',
          description: 'Test Feb Comm',
          run_date: '2019-01-31 06:00:00',
          start_date: '2019-01-01 06:00:00',
          end_date: '2019-02-01 05:59:59',
          status: {
            id: '2',
            description: 'Completed'
          },
          period: {
            period_id: '12019',
            description: 'January 2019',
            start_date: '2019-01-01 06:00:00',
            end_date: '2019-02-01 05:59:59',
            type: {
              description: 'Monthly',
              id: '2'
            }
          }
        },
        id: '1562967231'
      }
      const expectedCommissionDates = {
        accepted_date: '2019-01-31 06:00:00',
        description: 'Test Feb Comm',
        run_date: '2019-01-31 06:00:00',
        start_date: '2019-01-01 06:00:00',
        end_date: '2019-02-01 05:59:59',
        status: {
          id: '2',
          description: 'Completed'
        },
        period: {
          period_id: '12019',
          description: 'January 2019',
          start_date: '2019-01-01 06:00:00',
          end_date: '2019-02-01 05:59:59',
          type: {
            description: 'Monthly',
            id: '2'
          }
        }
      }

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.deepEqual(out0.commission_run, expectedCommissionDates)
      assert.strictEqual(out0.bonuses[0].a_date, '2019-02-01 05:59:59')
      assert.strictEqual(out0.bonuses[1].b_date, '2019-02-01 05:59:59')
      assert.deepEqual(out0, expectedOutput)
    })

    it('Formats date attribute values to given format', async () => {
      const formatOut = 'YYYY-MM-DD HH:mm:ss'
      opts.bus.inQueueData = [{
        icentris_client: 'idlife',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '09/01/2018 5:09:41 AM',
        birth_date: '07/24/1970'
      }, {
        icentris_client: 'stampinup',
        city: 'Salt Lake City',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '09/01/2018 5:09:41 AM'
      }]

      await bot.handle(opts.event, opts.context)

      const zone0 = _timezones[opts.bus.inQueueData[0].icentris_client]
      const zone1 = _timezones[opts.bus.inQueueData[1].icentris_client]

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      const outDate0 = moment(new Date(`${opts.bus.inQueueData[0].signup_date} ${zone0}`)).format(formatOut)
      const outDate1 = moment(new Date(`${opts.bus.inQueueData[1].signup_date} ${zone1}`)).format(formatOut)
      const outDate3 = moment(new Date(`${opts.bus.inQueueData[0].birth_date} ${zone0}`)).format(formatOut)
      assert.strictEqual(outDate0, out0.signup_date)
      assert.strictEqual(outDate1, out1.signup_date)
      assert.strictEqual(outDate3, out0.birth_date)
    })

    it('Passes any date(s) with in UTC, Z, and other UTC representations', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: 'Thu Sep 20 2018 18:03:11 GMT+0000 (UTC)'
      }, {
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '2019-09-21T18:03:11.150Z'
      }]

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(out0.signup_date, '2018-09-20 18:03:11')
      assert.strictEqual(out1.signup_date, '2019-09-21 18:03:11')
    })

    it('Passes values through if given invalid date values', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: null
      }, {
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: ''
      }]

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload

      assert.strictEqual(null, out0.signup_date)
      assert.strictEqual('', out1.signup_date)
    })

    // EDT Offset: UTC -4
    it('transforms dates from  EDT to UTC', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'clientEDT',
        city: 'New York',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: 'Mon, 06 Mar 2017 4:53:41 PM'
      }]
      const expectedDate = '2017-03-06 20:53:41'
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.strictEqual(out0.signup_date, expectedDate)
    })

    // CDT Offset: UTC -5
    it('transforms dates in default format from  CDT to UTC', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'idlife',
        city: 'chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '09/01/2018 5:09:41 AM'
      }]
      const expectedDate = '2018-09-01 10:09:41'
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload

      assert.strictEqual(out0.signup_date, expectedDate)
    })

    // CST Offset: UTC -6
    it('transforms dates in default format from  CST to UTC', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'clientCST',
        city: 'chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '09/01/2018 5:09:41 AM'
      }]
      const expectedDate = '2018-09-01 11:09:41'
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload

      assert.strictEqual(out0.signup_date, expectedDate)
    })

    // MDT Offset: UTC -6
    it('transforms dates from  MDT to UTC', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'nevetica',
        city: 'denver',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '09/02/2018 5:09:41 AM'
      }]

      const expectedDate = '2018-09-02 11:09:41'
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.strictEqual(out0.signup_date, expectedDate)
    })

    // PDT Offset: UTC -7
    it('transforms dates from  PDT to UTC', async function () {
      opts.bus.inQueueData = [{
        icentris_client: 'clientPDT',
        city: 'Los Angeles',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '2018-09-01 5:09:41 AM'
      }]
      const expectedDate = '2018-09-01 12:09:41'
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.strictEqual(out0.signup_date, expectedDate)
    })

    it('should format 12-hour clock without space', async () => {
      opts.bus.inQueueData = [{
        icentris_client: 'bluesun',
        city: 'Chicago',
        first_name: 'First',
        last_name: 'Last',
        company_name: 'Acme Co',
        signup_date: '08/01/2019 12:00AM'
      }]

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload

      assert.strictEqual(out0.signup_date, '2019-08-01 05:00:00')
    })
  })
}
