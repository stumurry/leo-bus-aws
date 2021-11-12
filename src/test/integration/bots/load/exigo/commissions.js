'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/commission')

    const customer = {
      CustomerID: 2,
      FirstName: 'Anakin',
      MiddleName: '',
      LastName: 'Skywalker',
      NameSuffix: 'Mr',
      Company: 'Imperial Fleet',
      CustomerTypeID: 1,
      CustomerStatusID: 1,
      Email: 'askywalker@icentris.com',
      'Phone ': 12345,
      'Phone2 ': 12345,
      'MobilePhone ': 12345,
      'Fax ': 12345,
      'MainAddress1 ': '1 Force Lane',
      'MainAddress3 ': ' ',
      MainCity: 'Center',
      MainState: 'Death Star',
      MainZip: '000000',
      MainCountry: ' ',
      MainCounty: ' ',
      MainVerified: 1,
      'MailAddress1 ': ' ',
      'MailAddress3 ': ' ',
      MailCity: ' ',
      MailState: ' ',
      MailZip: ' ',
      MailCountry: ' ',
      MailCounty: ' ',
      MailVerified: 1,
      'OtherAddress1 ': ' ',
      'OtherAddress3 ': ' ',
      OtherCity: ' ',
      OtherState: ' ',
      OtherZip: ' ',
      OtherCountry: ' ',
      OtherCounty: ' ',
      OtherVerified: 1,
      CanLogin: 1,
      CurrencyCode: 321,
      PayableToName: ' ',
      PayableTypeID: 1,
      CheckThreshold: 3.58,
      Gender: 'M',
      TaxCode: 'ASDF',
      TaxCodeTypeID: 1,
      IsSalesTaxExempt: 1,
      SalesTaxCode: '0',
      SalesTaxExemptExpireDate: '2008-11-11 13:23:44',
      VatRegistration: ' ',
      BinaryPlacementTypeID: 1,
      UseBinaryHoldingTank: 1,
      IsInBinaryHoldingTank: 1,
      Field1: '1',
      Field2: '0',
      Field3: '0',
      Field4: '0',
      Field5: '0',
      Field6: '0',
      Field7: '1',
      Field8: '0',
      Field9: '0',
      Field10: '0',
      Field11: '0',
      Field12: '0',
      Field13: '0',
      Field14: '0',
      Field15: '0',
      CreatedDate: '2008-11-11 13:23:44',
      ModifiedDate: '2008-11-11 13:23:44',
      CreatedBy: 'Supreme Commander',
      ModifiedBy: 'Supreme Commander'
    }

    const commissionRun = {
      CommissionRunID: 2389,
      CommissionRunDescription: 'Week 112 3/7-3/13',
      PeriodTypeID: 2,
      PeriodID: 112,
      RunDate: '2016-03-16T10:28:00',
      AcceptedDate: '2016-03-16T10:38:00',
      CommissionRunStatusID: 3,
      HideFromWeb: '0',
      PlanID: 2
    }

    const commissionRunStatus = {
      CommissionRunStatusID: 3,
      CommissionRunStatusDescription: 'Accepted'
    }

    const period = {
      PeriodTypeID: 2,
      PeriodID: 112,
      PeriodDescription: 'April 2023',
      StartDate: '2023-04-01T02:00:00',
      EndDate: '2023-04-30T02:00:00',
      AcceptedDate: null
    }

    const commission = {
      CommissionRunID: 2389,
      CustomerID: 1,
      CurrencyCode: 'usd',
      Earnings: 100.0000,
      PreviousBalance: 0.0000,
      BalanceForward: 0.0000,
      Fee: 0.0000,
      Total: 100.0000
    }

    const commission2 = {
      CommissionRunID: 2389,
      CustomerID: 2,
      CurrencyCode: 'usd',
      Earnings: 100.0000,
      PreviousBalance: 0.0000,
      BalanceForward: 0.0000,
      Fee: 0.0000,
      Total: 100.0000
    }

    const commissionBonuses = {
      CommissionRunID: 2389,
      CustomerID: 1,
      BonusID: 1,
      Amount: 50.0000
    }

    const commissionBonuses2 = {
      CommissionRunID: 2389,
      CustomerID: 2,
      BonusID: 1,
      Amount: 100.0000
    }

    const bonus = {
      BonusID: 1,
      BonusDescription: 'Retail Bonus',
      PeriodTypeID: 1
    }

    await opts.mssql.insertAll([
      { Customers: customer },
      { CommissionBonuses: commissionBonuses },
      { CommissionBonuses: commissionBonuses2 },
      { Commissions: commission2 },
      { Commissions: commission },
      { Periods: period },
      { CommissionRunStatuses: commissionRunStatus },
      { CommissionRuns: commissionRun },
      { Bonuses: bonus }
    ])
  })

  after(async () => {
    delete opts.event.icentris_client

    await opts.mssql.executeAll([
      'DELETE FROM [Commissions] WHERE CustomerID = 1',
      'DELETE FROM [Commissions] WHERE CustomerID = 2',
      'DELETE FROM [CommissionRuns] WHERE CommissionRunID = 2389',
      'DELETE FROM [CommissionRunStatuses] WHERE CommissionRunStatusID = 3',
      'DELETE FROM [Periods] WHERE PeriodID = 112',
      'DELETE FROM [Customers] WHERE CustomerID = 2',
      'DELETE FROM [CommissionBonuses] WHERE CustomerID = 1',
      'DELETE FROM [CommissionBonuses] WHERE CustomerID = 2',
      'DELETE FROM [Bonuses] WHERE BonusID = 1'
    ])
  })

  describe('#handle', function () {
    it('should load exigo cdc [Commissions] changes using domainobject into queue', async function () {
      this.timeout(5000)

      // opts.bus.inQueueData = [{
      //   'delete': {},
      //   'insert': {},
      //   'update': {
      //     'idlife': {
      //       'Commissions': [
      //         { CommissionRunID: 2389, CustomerID: 1 },
      //         { CommissionRunID: 2389, CustomerID: 2 }
      //       ]
      //     }
      //   }
      // }]

      opts.bus.inQueueData = [{
        insert: {},
        update: {
          idlife: {
            Orders: [
              {
                OrderID: 10
              },
              {
                OrderID: 9
              },
              {
                OrderID: 8
              },
              {
                OrderID: 7
              },
              {
                OrderID: 6
              },
              {
                OrderID: 5
              },
              {
                OrderID: 4
              },
              {
                OrderID: 3
              },
              {
                OrderID: 2
              },
              {
                OrderID: 1
              }
            ],
            Customers: [
              {
                CustomerID: 10
              },
              {
                CustomerID: 9
              },
              {
                CustomerID: 8
              },
              {
                CustomerID: 7
              },
              {
                CustomerID: 6
              },
              {
                CustomerID: 5
              },
              {
                CustomerID: 4
              },
              {
                CustomerID: 3
              },
              {
                CustomerID: 2
              },
              {
                CustomerID: 1
              }
            ],
            Commissions: [
              {
                CommissionRunID: 2389,
                CustomerID: 1
              },
              {
                CommissionRunID: 2389,
                CustomerID: 2
              }
            ]
          }
        },
        delete: {}
      }]

      await bot.handle(opts.event, opts.context)
      assert.strictEqual(opts.bus.outQueueData.length, 2)
    })
  })
}
