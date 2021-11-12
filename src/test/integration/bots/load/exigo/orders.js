'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/order')

    const order = {
      OrderID: 10014521,
      CustomerID: 1,
      OrderStatusID: 8,
      OrderDate: '2014-01-20T01:02:03Z',
      CurrencyCode: 'USD',
      WarehouseID: 1,
      ShipMethodID: 2,
      OrderTypeID: 9,
      PriceTypeID: 2,
      FirstName: 'RaynePreferredwithAutoshipTWO',
      MiddleName: '',
      LastName: 'Test',
      NameSuffix: '',
      Company: '',
      Address1: '707 W 700 S',
      Address2: 'DO NOT SHIP',
      Address3: '',
      City: 'Woods Cross',
      State: 'UT',
      Zip: '84087',
      Country: 'US',
      County: '',
      Email: 'rayne.moore@icentris.com',
      Phone: '',
      Notes: '',
      Total: 21.9700,
      SubTotal: 13.4500,
      TaxTotal: 0.0000,
      ShippingTotal: 8.5200,
      DiscountTotal: 0.0000,
      DiscountPercent: 0.0000,
      WeightTotal: 0.1230,
      BusinessVolumeTotal: 10.4700,
      CommissionableVolumeTotal: 7.8500,
      TrackingNumber1: '',
      TrackingNumber2: '',
      TrackingNumber3: '',
      TrackingNumber4: '',
      TrackingNumber5: '',
      Other1Total: 0.0000,
      Other2Total: 0.0000,
      Other3Total: 0.0000,
      Other4Total: 0.0000,
      Other5Total: 0.0000,
      Other6Total: 0.0000,
      Other7Total: 0.0000,
      Other8Total: 0.0000,
      Other9Total: 0.0000,
      Other10Total: 0.0000,
      ShippingTax: 0.0000,
      OrderTax: 0.0000,
      FedTaxTotal: 0.0000,
      StateTaxTotal: 0.0000,
      FedShippingTax: 0.0000,
      StateShippingTax: 0.0000,
      CityShippingTax: 0.0000,
      CityLocalShippingTax: 0.0000,
      CountyShippingTax: 0.0000,
      CountyLocalShippingTax: 0.0000,
      Other11: '1/18/2014 1:21:00 AM',
      Other12: '',
      Other13: '',
      Other14: '',
      Other15: '',
      Other16: '',
      Other17: '',
      Other18: '',
      Other19: '',
      Other20: '',
      IsCommissionable: '1',
      AutoOrderID: null,
      ReturnOrderID: null,
      ReplacementOrderID: null,
      ParentOrderID: null,
      BatchID: 30,
      DeclineCount: 0,
      TransferToCustomerID: null,
      PartyID: null,
      WebCarrierID1: null,
      WebCarrierID2: null,
      WebCarrierID3: null,
      WebCarrierID4: null,
      WebCarrierID5: null,
      ShippedDate: null,
      CreatedDate: '2014-01-18T01:21:09.053',
      LockedDate: null,
      ModifiedDate: '2014-07-30T12:51:54.42',
      CreatedBy: 'API_Icentris',
      ModifiedBy: 'TriciaS',
      SuppressPackSlipPrice: '0',
      ReturnCategoryID: null,
      ReplacementCategoryID: null,
      IsRMA: '0',
      TaxIntegrationCalculate: null,
      TaxIntegrationCommit: null
    }

    const autoOrder = {
      AutoOrderID: 90024619,
      CustomerID: 1,
      AutoOrderStatusID: 2,
      FrequencyTypeID: 3,
      StartDate: '2014-02-18T00:00:00',
      StopDate: null,
      LastRunDate: null,
      NextRunDate: '2014-02-18T00:00:00',
      CancelledDate: '2018-02-19T10:47:06.227',
      CurrencyCode: 'USD',
      WarehouseID: 1,
      ShipMethodID: 18,
      AutoOrderPaymentTypeID: 1,
      AutoOrderProcessTypeID: 1,
      FirstName: 'RaynePreferredwithAutoshipTWO',
      MiddleName: '',
      LastName: 'Test',
      NameSuffix: '',
      Company: '',
      Address1: '707 W 700 S',
      Address2: 'DO NOT SHIP',
      Address3: '',
      City: 'Woods Cross',
      State: 'UT',
      Zip: '84087',
      Country: 'US',
      County: '',
      Email: 'rayne.moore@icentris.com',
      Phone: '',
      Notes: '',
      Total: 24.2000,
      SubTotal: 10.4700,
      TaxTotal: 0.3100,
      ShippingTotal: 13.4200,
      DiscountTotal: 0.0000,
      BusinessVolumeTotal: 10.4700,
      CommissionableVolumeTotal: 7.8500,
      AutoOrderDescription: '',
      Other11: '',
      Other12: '',
      Other13: '',
      Other14: '',
      Other15: '',
      Other16: '',
      Other17: '',
      Other18: '',
      Other19: '',
      Other20: '',
      CreatedDate: '2014-01-18T01:21:10.427',
      ModifiedDate: '2018-02-19T10:47:00',
      CreatedBy: 'API_Icentris',
      ModifiedBy: 'Administrator'
    }

    const orderDetail = {
      OrderID: 10014521,
      OrderLine: 1,
      ItemID: 6,
      ItemCode: '03-0001',
      ItemDescription: 'Energy Chew - Chocolate',
      Quantity: 1.0000,
      PriceEach: 13.4500,
      PriceTotal: 13.4500,
      Tax: 0.0000,
      WeightEach: 0.1230,
      Weight: 0.1230,
      BusinessVolumeEach: 10.4700,
      BusinessVolume: 10.4700,
      CommissionableVolumeEach: 7.8500,
      CommissionableVolume: 7.8500,
      Other1Each: 0.0000,
      Other1: 0.0000,
      Other2Each: 0.0000,
      Other2: 0.0000,
      Other3Each: 0.0000,
      Other3: 0.0000,
      Other4Each: 0.0000,
      Other4: 0.0000,
      Other5Each: 0.0000,
      Other5: 0.0000,
      OriginalTaxableEach: 13.4500,
      OriginalBusinessVolumeEach: 10.4700,
      OriginalCommissionableVolumeEach: 7.8500,
      Other6Each: 0.0000,
      Other6: 0.0000,
      Other7Each: 0.0000,
      Other7: 0.0000,
      Other8Each: 0.0000,
      Other8: 0.0000,
      Other9Each: 0.0000,
      Other9: 0.0000,
      Other10Each: 0.0000,
      Other10: 0.0000,
      ParentItemID: null,
      Taxable: 13.4500,
      FedTax: 0.0000,
      StateTax: 0.0000,
      CityTax: 0.0000,
      CityLocalTax: 0.0000,
      CountyTax: 0.0000,
      CountyLocalTax: 0.0000,
      ManualTax: 0.0000,
      IsStateTaxOverride: '0',
      Reference1: ''
    }

    await opts.mssql.insertAll([
      { Orders: order },
      { AutoOrders: autoOrder },
      { OrderDetails: orderDetail }
    ])
  })

  after(async () => {
    delete opts.event.icentris_client

    await opts.mssql.executeAll([
      'DELETE FROM [Orders] WHERE OrderID = 10014521',
      'DELETE FROM [AutoOrders] WHERE AutoOrderID = 90024619',
      'DELETE FROM [OrderDetails] WHERE OrderID = 10014521'
    ])
  })

  describe('#handle', function () {
    it('should load exigo cdc [order] changes using domainobject into queue', async function () {
      this.timeout(5000)

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            Orders: [
              {
                OrderID: 10014521
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)
    })

    it('should format order_date correctly', async function () {
      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            Orders: [
              {
                OrderID: 10014521
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload
      const orderDate = out0.order_date
      assert.strictEqual(orderDate, '2014-01-20 01:02:03', 'order_date formatted incorrectly')
      assert.strictEqual(out0.total, 21.97)
    })
  })
}
