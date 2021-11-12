'use strict'

const faker = require('faker')
const rand = require('../libs/utils').rand
const moment = require('moment')
const Promise = require('bluebird')

/**
 * @author smurry
 * @date 7/2/19
 * Execute this script only after the first unit test.
 * Once executed, you must down and up your docker fullstack,
 * otherwise all CDC tests will fail.
 */

class Obj {
  getObject () {
    throw new Error('abstract method getSchema not implemented!')
  }

  getTbl () {
    throw new Error('abstract method getTbl not implemented!')
  }

  generateObjects () {
    const r = rand(20, 100)
    const rows = []
    let i
    for (i = 0; i < r; i++) {
      rows.push(this.getObject())
    }

    return rows
  }

  async truncate (tbl) {
    return this.mssql.execute(`TRUNCATE TABLE ${tbl}`)
  }

  async insert (tbl, rows) {
    const sql = this.mssql.squel.insert()
      .into(tbl)
      .setFieldsRows(rows)
      .toString()

    return this.mssql.execute(sql)
  }
}

class Customer extends Obj {
  constructor () {
    super()

    this.customerID = 0
  }

  getCustomerID () {
    return ++this.customerID
  }

  getObject () {
    return {
      CustomerID: this.getCustomerID(),
      FirstName: faker.name.firstName(),
      MiddleName: faker.name.firstName(),
      LastName: faker.name.lastName(),
      NameSuffix: faker.name.suffix(),
      Company: faker.company.companyName(),
      CustomerTypeID: 1,
      CustomerStatusID: 1,
      Email: faker.internet.email(),
      Phone: '1234567890',
      Phone2: '',
      MobilePhone: '',
      Fax: '',
      MainAddress1: faker.address.streetAddress(),
      MainAddress3: ' ',
      MainCity: faker.address.city(),
      MainState: faker.address.state(),
      MainZip: faker.address.zipCode(),
      MainCountry: faker.address.country(),
      MainCounty: faker.address.county(),
      MainVerified: 1,
      MailAddress1: ' ',
      MailAddress3: ' ',
      MailCity: ' ',
      MailState: ' ',
      MailZip: ' ',
      MailCountry: ' ',
      MailCounty: ' ',
      MailVerified: 1,
      OtherAddress1: ' ',
      OtherAddress3: ' ',
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
      CreatedDate: moment().subtract(rand(5, 30), 'day').format('Y-MM-DD HH:mm:ss'),
      ModifiedDate: moment().format('Y-MM-DD HH:mm:ss'),
      CreatedBy: faker.name.findName(),
      ModifiedBy: faker.name.findName()
    }
  }

  getTbl () {
    return 'Customers'
  }
}

class Order extends Obj {
  constructor () {
    super()

    this.orderID = 0
  }

  getOrderID () {
    return ++this.orderID
  }

  getObject () {
    const orderId = this.getOrderID()
    const o = {
      OrderID: orderId,
      CustomerID: orderId,
      OrderStatusID: 1,
      OrderDate: '2008-11-11 13:23:44',
      CurrencyCode: 'USD',
      WarehouseID: 1,
      ShipMethodID: 1,
      OrderTypeID: 1,
      PriceTypeID: 1,
      FirstName: faker.name.firstName(),
      MiddleName: ' ',
      LastName: faker.name.lastName(),
      NameSuffix: faker.name.suffix(),
      Company: faker.company.companyName(0),
      Address1: faker.address.streetAddress(false),
      Address2: ' ',
      Address3: ' ',
      City: faker.address.city(),
      State: faker.address.state(),
      Zip: faker.address.zipCode(),
      Country: 'US',
      County: 'Depends',
      Email: 'askywalker@icentris.com',
      Phone: faker.phone.phoneNumber(),
      Notes: faker.lorem.paragraph(),
      Total: 9.99,
      SubTotal: 9.99,
      TaxTotal: 9.99,
      ShippingTotal: 9.99,
      DiscountTotal: 9.99,
      DiscountPercent: 9.99,
      WeightTotal: 9.99,
      BusinessVolumeTotal: 9.99,
      CommissionableVolumeTotal: 9.99,
      TrackingNumber1: 'Obi-Wan',
      TrackingNumber2: 'Obi-Wan',
      TrackingNumber3: 'Obi-Wan',
      TrackingNumber4: 'Obi-Wan',
      TrackingNumber5: 'Obi-Wan',
      Other1Total: 9.99,
      Other2Total: 9.99,
      Other3Total: 9.99,
      Other4Total: 9.99,
      Other5Total: 9.99,
      Other6Total: 9.99,
      Other7Total: 9.99,
      Other8Total: 9.99,
      Other9Total: 9.99,
      Other10Total: 9.99,
      ShippingTax: 9.99,
      OrderTax: 9.99,
      FedTaxTotal: 9.99,
      StateTaxTotal: 9.99,
      FedShippingTax: 9.99,
      StateShippingTax: 9.99,
      CityShippingTax: 9.99,
      CityLocalShippingTax: 9.99,
      CountyShippingTax: 9.99,
      CountyLocalShippingTax: 9.99,
      IsCommissionable: 1,
      AutoOrderID: 1,
      ReturnOrderID: 1,
      ReplacementOrderID: 1,
      ParentOrderID: 1,
      BatchID: 1,
      DeclineCount: 0,
      CreatedDate: moment().subtract(rand(5, 30), 'day').format('Y-MM-DD HH:mm:ss'),
      ModifiedDate: moment().format('Y-MM-DD HH:mm:ss'),
      CreatedBy: faker.name.findName(),
      ModifiedBy: faker.name.findName(),
      SuppressPackSlipPrice: 1,
      IsRMA: 1
    }
    return o
  }

  getTbl () {
    return 'Orders'
  }
}

const main = async () => {
  try {
    const klasses = [Customer, Order]

    Obj.prototype.mssql = await require('../libs/mssql')(require('../test/config.json').bus.tenant.idlife.exigo)

    await Promise.map(klasses, K => {
      const o = new K()

      const rows = o.generateObjects()
      const tbl = o.getTbl()

      return o.truncate(tbl).then(rs => {
        return o.insert(tbl, rows)
      })
    })

    Obj.prototype.mssql.end()
  } catch (err) {
    Obj.prototype.mssql.end()
    console.log(err)
  }
}

main()
