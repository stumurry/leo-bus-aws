'use strict'

const request = require('superagent')
const Bot = require('../../../bot')
const _ = require('lodash')
const Log = require('../../../../libs/log')
const utils = require('./../../../../libs/utils')
const moment = require('moment')

const commandTemplate = `<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:trin="http://trinitysoft.net/">
   <soap:Header/>
   <soap:Body>
      <trin:RunCommand>
         <trin:Token>__Token__</trin:Token>
         <trin:Context>__Context__</trin:Context>
         <trin:DealerID>__DealerID__</trin:DealerID>
         <trin:XMLString><![CDATA[<?xml version="1.0" encoding="utf-8"?><COMMANDREQUEST><COMMANDS numcommands="1"><COMMAND><COMMANDNAME>REALTIMEVOLUME</COMMANDNAME><ARGUMENTS numargs="1"><ARGUMENT><ARGUMENTNAME>PERIOD</ARGUMENTNAME><ARGUMENTVALUE>CURRENT</ARGUMENTVALUE></ARGUMENT></ARGUMENTS></COMMAND></COMMANDS></COMMANDREQUEST>]]></trin:XMLString>
      </trin:RunCommand>
   </soap:Body>
</soap:Envelope>`

class SummaryDataFetchBot extends Bot {
  constructor (bus) {
    super(bus)
    this.xml2js = this.bus.Promise.promisifyAll(require('xml2js'))
  }

  async handle (event, context) {
    super.handle(event, context)

    return this.transform(
      this.botId,
      event.source,
      event.destination,
      (payload, meta, done) => {
        this.each(payload)
          .then(obj => {
            if (obj) {
              done(null, obj)
            } else {
              done(null, true)
            }
          })
          .catch(err => {
            console.log('error being caught')
            console.log(err)
            done(err)
          })
      }
    )
  }

  getRequestTemplate (opts, _template) {
    Object.keys(opts).forEach(k => {
      _template = _template.replace(new RegExp(`${k}`, 'g'), opts[k])
    })
    return _template
  }

  async each (payload) {
    if (!payload.icentris_client) {
      return
    }

    return this.getConfig(payload.icentris_client)
      .then(cfg => {
        if (!_.has(cfg, 'trinity')) {
          throw new Error(`Missing trinity cfg for client ${payload.icentris_client}`, cfg)
        }

        const wsdlPath = `${cfg.trinity.trinity_wsdl_url}/FirestormWebServices/FirestormMobileWS.asmx`

        if (!cfg.trinity.token || !cfg.trinity.context || !wsdlPath) {
          throw new Error(`Missing token or context or wsdlPath. token is ${cfg.trinity.token} context is ${cfg.trinity.context} wsdlPath is ${wsdlPath}`)
        }

        if (!_.has(payload, 'event_payload.client_user_id')) {
          throw new Error('Missing client_user_id', payload)
        }

        const dealerId = payload.event_payload.jit_user_id
        const requestTemplate = this.getRequestTemplate({
          __Token__: cfg.trinity.token,
          __Context__: cfg.trinity.context,
          __DealerID__: dealerId
        }, commandTemplate)

        // Soap operation
        return request.post(wsdlPath)
          .set('Content-Type', 'text/xml;charset=utf-8')
          .set('Accept-Encoding', 'gzip,deflate')
          .set('Content-Length', requestTemplate.length)
          .set('SOAPAction', 'http://trinitysoft.net/RunCommand')
          .send(requestTemplate)
      })
      .then(clientResponse => {
        return this.xml2js.parseStringAsync(clientResponse.text)
      })
      .then(result => {
        const commandResponse = result['soap:Envelope']['soap:Body'][0].RunCommandResponse[0].RunCommandResult[0]
        return this.xml2js.parseStringAsync(commandResponse)
      })
      .then(commandResponse => {
        const responseData = commandResponse.RESPONSE.COMMANDRESPONSE[0].COMMANDRESPONSEDATA[0]
        if (responseData.FAILURERESPONSE && responseData.FAILURERESPONSE[0]) {
          Log.error(payload.icentris_client, 'Failure response from web service', {
            data: payload.event_payload,
            failure_response_body: responseData.FAILURERESPONSE[0]
          })
          return
        } else if (responseData.ERRORRESPONSE && responseData.ERRORRESPONSE[0]) {
          Log.error(payload.icentris_client, 'error response from web service', {
            data: payload.event_payload,
            error_response_body: responseData.ERRORRESPONSE[0]
          })
          return
        }
        const rows = responseData.SUCCESSRESPONSE[0].REPORT[0].ROW
        if (rows.length === 1 && (rows[0].split('|').find(i => i !== '0') === undefined)) {
          Log.info(payload.icentris_client, `Dealer ID ${payload.event_payload.jit_user_id} was not found in Firestorm.`, {
            data: payload.event_payload
          })

          return
        } else if (rows.length === 2 && rows[1] === '') {
          Log.info(payload.icentris_client, `Dealer ID ${payload.event_payload.jit_user_id} was not found in Firestorm.`, {
            data: payload.event_payload
          })

          rows[1] = this.buildCacheStub()
        } else if (rows.length < 2) {
          throw new Error('Result valueArray does not contain expected number of elements')
        }

        let arr = rows[0].split('|')

        const realTime = {
          icentris_client: payload.icentris_client,
          DealerID: arr[0],
          IsBCQ: parseInt(arr[1]) === 0 ? 0 : 1,
          CurrentPeriodPV: arr[2],
          CurrentPeriodGV: arr[3],
          SPCGVMVR: arr[4],
          APCGVMVR: arr[5],
          RPCGVMVR: arr[6],
          DRGVMVR: arr[7],
          ADGVMVR: arr[8],
          RDGVMVR: arr[9],
          NDGVMVR: arr[10],
          VPGVMVR: arr[11],
          PDGVMVR: arr[12],
          IPGVMVR: arr[13],
          DIGVMVR: arr[14],
          BDGVMVR: arr[15],
          BLDGVMVR: arr[16],
          GBDVMVR: arr[17],
          CommissionableVolume: arr[18],
          GVWithMVR: arr[19],
          BCQLegs: arr[20],
          RPCLegs: arr[21],
          ADLegs: arr[22],
          NDLegs: arr[23],
          VPLegs: arr[24],
          NewGenQ: arr[25],
          TotalRetailCustomers: arr[26],
          TotalActivePetConsultants: arr[27],
          TotalGroupPetConsultants: arr[28],
          NewTeamRankAdvancements: arr[29],
          NewPreferredCustomersLast30Days: arr[30],
          TotalPreferredCustomers: arr[31],
          DealershipID: arr[32],
          CurrentDealershipTypeID: arr[33],
          LifetimeDealershipTypeID: arr[34],
          CurrMonthPaidRank: arr[35],
          CurrMonthLifetimeRank: arr[36],
          NewGroupRecruitsLast30Days: arr[37]
        }

        arr = rows[1].split('|')

        const cached = {
          icentris_client: payload.icentris_client,
          DealershipID: arr[0],
          DealerID: arr[1],
          LifetimeDealershipTypeID: arr[2],
          CurrMonthLifetimeRank: arr[3],
          CurrentDealershipTypeID: arr[4],
          CurrMonthPaidRank: arr[5],
          CurrentPeriodPV: arr[6],
          CurrentPeriodGV: arr[7],
          CurrentPeriodQV: arr[8],
          GVWithMVR: arr[9],
          BCQLegs: arr[10],
          APCLegs: arr[11],
          RPCLegs: arr[12],
          ADLegs: arr[13],
          RDLegs: arr[14],
          NDLegs: arr[15],
          VPLegs: arr[16],
          PDLegs: arr[17],
          IPLegs: arr[18],
          DILegs: arr[19],
          BLDLegs: arr[20],
          IsBCQ: parseInt(arr[21]) === 0 ? 0 : 1,
          CurrentPeriodCustomerPV: arr[22],
          CommissionableVolume: arr[23],
          NewRecruits: arr[24],
          NewGroupRecruits: arr[25],
          NewCustomers: arr[26],
          CustomerOrderCount: arr[27],
          PersonalCustomerVolumeAutoship: arr[28],
          NewGenQ: arr[29],
          NewGroupRecruitsLast30Days: arr[30],
          TotalGroupPetConsultants: arr[31],
          TotalActivePetConsultants: arr[32],
          TotalRetailCustomers: arr[33],
          NewTeamRankAdvancements: arr[34],
          NewPreferredCustomersLast30Days: arr[35],
          TotalPreferredCustomers: arr[36],
          SPCLegs: arr[37],
          DRLegs: arr[38],
          BDLegs: arr[39],
          GBDLegs: arr[40],
          PeriodStartDate: arr[41],
          PeriodEndDate: arr[42],
          PeriodID: arr[43],
          PeriodDescription: arr[44],
          PeriodType: arr[45]
        }

        Log.info(payload.icentris_client, `Memory consumed: ${(process.memoryUsage().heapUsed / 1024 / 1024).toPrecision(4)}MB`)

        return Object.assign(cached, realTime)
      })
      .catch(error => {
        Log.info(payload.icentris_client, `Memory consumed: ${(process.memoryUsage().heapUsed / 1024 / 1024).toPrecision(4)}MB`)

        Log.error(payload.icentris_client, `This error was found ${error}`, {
          data: payload.event_payload
        })
      })
  }

  buildCacheStub () {
    const periodDate = moment()

    const periodStartDate = utils.formatDateToUTC(periodDate, 'MDT', 'MM/DD/YYYY hh:mm:ss A')
    const periodEndDate = periodStartDate
    const periodID = `${periodDate.month() + 1}${periodDate.year()}`
    const periodDescription = `${periodDate.format('MMMM')} ${periodDate.year()}`
    const periodType = 'Monthly'
    return '0|'.repeat(41) + `${periodStartDate}|${periodEndDate}|${periodID}|${periodDescription}|${periodType}`
  }
}

module.exports = new SummaryDataFetchBot()
