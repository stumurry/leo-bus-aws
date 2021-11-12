'use strict'

const Bot = require('../bot')
const moment = require('moment')

class LoadExigoOrderBot extends Bot {
  getTableIdTranslations () {
    return {
      Orders: true,
      OrderDetails: true
    }
  }

  getDomainIdColumn () {
    return 'OrderID'
  }

  getDomainObject (dol) {
    return dol.domainObject(c => {
      // https://github.com/iCentris/leo-bus/wiki/Order
      // https://github.com/iCentris/etl/blob/master/bin/ruby/exigo/new/extract_orders.rb

      return `
        select 
              
        o.OrderID,
        o.CustomerID, 
        o.OrderDate, 
        o.OrderStatusID,
        o.Total,
        os.OrderStatusDescription,
        o.BusinessVolumeTotal, 
        o.CommissionableVolumeTotal, 
        o.CustomerID,

        (SELECT
          a.ItemDescription, 
          a.Quantity, 
          a.PriceEach, 
          a.PriceTotal, 
          a.BusinessVolumeEach,
          a.BusinessVolume,
          a.CommissionableVolumeEach, 
          a.CommissionableVolume
          from orderdetails a where a.OrderID = o.OrderID 
          FOR JSON PATH
        ) as OrderDetails,

        ao.AutoOrderID,
        ao.NextRunDate,
        aos.AutoOrderStatusID,
        aos.AutoOrderStatusDescription

        from orders o
        left outer join OrderStatuses os on os.OrderStatusID = o.OrderStatusID
        left outer join autoorders ao on ao.customerid = o.customerid
        left outer join autoorderstatuses aos on aos.AutoOrderStatusID = ao.AutoOrderStatusID

        WHERE o.OrderID IN (${c.ids})
        `
    })
  }

  transform (c) {
    const trackingNumbers = []
    if (c.TrackingNumber1) trackingNumbers.push(c.TrackingNumber1)
    if (c.TrackingNumber2) trackingNumbers.push(c.TrackingNumber2)
    if (c.TrackingNumber3) trackingNumbers.push(c.TrackingNumber3)
    if (c.TrackingNumber4) trackingNumbers.push(c.TrackingNumber4)
    if (c.TrackingNumber5) trackingNumbers.push(c.TrackingNumber5)

    var autoshipTemplate
    if (c.AutoOrderID) {
      autoshipTemplate = {
        id: c.AutoOrderID,
        next_run_date: c.NextRunDate,
        status: {
          id: c.AutoOrderStatusID,
          description: c.AutoOrderStatusDescription
        }
      }
    }

    var orderDetails
    if (c.OrderDetails) {
      const p = JSON.parse(c.OrderDetails)
      orderDetails = p.map(d => {
        return {
          sku: d.ItemCode,
          name: d.ItemDescription,
          // 'description': 'n/a',
          quantity: d.Quantity,
          unit_price: d.PriceEach,
          total_price: d.PriceTotal,
          unit_volume: d.BusinessVolumeEach,
          unit_commission_volume: d.CommissionableVolumeEach,
          total_volume: d.BusinessVolume,
          total_commission_volume: d.CommissionableVolume
        }
      })
    }

    var status
    if (c.OrderStatusID) {
      status = {
        id: c.OrderStatusID,
        description: c.OrderStatusDescription
      }
    }

    return {
      order_id: c.OrderID,
      // "tree_user_id": "<populated in MAP step>",
      // "status_id": "<populated in MAP step>",
      client_user_id: c.CustomerID,
      order_date: moment(c.OrderDate).utc().format('YYYY-MM-DD HH:mm:ss'),
      status: status,
      tracking_numbers: trackingNumbers,
      personal_volume: c.BusinessVolumeTotal, // ?
      total: c.Total,
      commission_volume: c.CommissionableVolumeTotal,
      autoship_template: autoshipTemplate,
      items: orderDetails,
      extra: {
        _comment: 'Takes custom properties for the specific client'
      }

    }
  }
}

module.exports = new LoadExigoOrderBot()
