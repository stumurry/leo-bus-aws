'use strict'

const fs = require('fs')
const moment = require('moment')
const utils = require('./../../../../../libs/utils')

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  const currDate = moment()
  const formattedCurrDate = utils.formatDateToUTC(currDate, 'MDT', 'MM/DD/YYYY hh:mm:ss A')
  const sampleMappings = {
    in0: {
      icentris_client: 'bluesun',
      event_type: 'summary-data',
      event_payload: { client_user_id: 'd40309', jit_user_id: '1234' }
    },
    out0: {
      icentris_client: 'bluesun',
      DealershipID: '787888',
      DealerID: '814055',
      LifetimeDealershipTypeID: '59',
      CurrMonthLifetimeRank: 'NPC',
      CurrentDealershipTypeID: '59',
      CurrMonthPaidRank: 'NPC',
      CurrentPeriodPV: '0.00',
      CurrentPeriodGV: '1425.00',
      CurrentPeriodQV: '0.00',
      BCQLegs: '0',
      APCLegs: '0',
      RPCLegs: '0',
      ADLegs: '0',
      RDLegs: '0',
      NDLegs: '0',
      VPLegs: '0',
      PDLegs: '0',
      IPLegs: '0',
      DILegs: '0',
      BLDLegs: '0',
      IsBCQ: '1',
      SPCLegs: '0',
      DRLegs: '0',
      BDLegs: '0',
      GBDLegs: '0',
      CurrentPeriodCustomerPV: '0.00',
      CommissionableVolume: '0.00',
      NewRecruits: '1',
      NewGroupRecruits: '0',
      NewCustomers: '0',
      CustomerOrderCount: '0.00',
      PersonalCustomerVolumeAutoship: '0.00',
      NewGenQ: '0',
      NewGroupRecruitsLast30Days: '3',
      TotalGroupPetConsultants: '26',
      TotalActivePetConsultants: '7',
      TotalRetailCustomers: '1',
      NewTeamRankAdvancements: '0',
      NewPreferredCustomersLast30Days: '0',
      TotalPreferredCustomers: '0',
      PeriodStartDate: '02/01/2019 12:00AM',
      PeriodEndDate: '02/28/2019 11:59PM',
      PeriodID: '22019',
      PeriodDescription: 'February 2019',
      PeriodType: 'Monthly',
      GVWithMVR: '1425.00',
      SPCGVMVR: '1425.00',
      APCGVMVR: '1425.00',
      RPCGVMVR: '1425.00',
      DRGVMVR: '475.00',
      ADGVMVR: '475.00',
      RDGVMVR: '475.00',
      NDGVMVR: '475.00',
      VPGVMVR: '475.00',
      PDGVMVR: '475.00',
      IPGVMVR: '475.00',
      DIGVMVR: '475.00',
      BDGVMVR: '475.00',
      BLDGVMVR: '475.00',
      GBDVMVR: '475.00'
    },
    out0ForEmptyRow2: {
      icentris_client: 'bluesun',
      DealershipID: '787888',
      DealerID: '814055',
      LifetimeDealershipTypeID: '59',
      CurrMonthLifetimeRank: 'NPC',
      CurrentDealershipTypeID: '59',
      CurrMonthPaidRank: 'NPC',
      CurrentPeriodPV: '0.00',
      CurrentPeriodGV: '1425.00',
      CurrentPeriodQV: '0',
      GVWithMVR: '1425.00',
      BCQLegs: '0',
      APCLegs: '0',
      RPCLegs: '0',
      ADLegs: '0',
      RDLegs: '0',
      NDLegs: '0',
      VPLegs: '0',
      PDLegs: '0',
      IPLegs: '0',
      DILegs: '0',
      BLDLegs: '0',
      IsBCQ: 1,
      CurrentPeriodCustomerPV: '0',
      CommissionableVolume: '0.00',
      NewRecruits: '0',
      NewGroupRecruits: '0',
      NewCustomers: '0',
      CustomerOrderCount: '0',
      PersonalCustomerVolumeAutoship: '0',
      NewGenQ: '0',
      NewGroupRecruitsLast30Days: '3',
      TotalGroupPetConsultants: '26',
      TotalActivePetConsultants: '7',
      TotalRetailCustomers: '1',
      NewTeamRankAdvancements: '0',
      NewPreferredCustomersLast30Days: '0',
      TotalPreferredCustomers: '0',
      SPCLegs: '0',
      DRLegs: '0',
      BDLegs: '0',
      GBDLegs: '0',
      PeriodStartDate: formattedCurrDate,
      PeriodEndDate: formattedCurrDate,
      PeriodID: `${currDate.month() + 1}${currDate.year()}`,
      PeriodDescription: `${currDate.format('MMMM')} ${currDate.year()}`,
      PeriodType: 'Monthly',
      SPCGVMVR: '1425.00',
      APCGVMVR: '1425.00',
      RPCGVMVR: '1425.00',
      DRGVMVR: '475.00',
      ADGVMVR: '475.00',
      RDGVMVR: '475.00',
      NDGVMVR: '475.00',
      VPGVMVR: '475.00',
      PDGVMVR: '475.00',
      IPGVMVR: '475.00',
      DIGVMVR: '475.00',
      BDGVMVR: '475.00',
      BLDGVMVR: '475.00',
      GBDVMVR: '475.00'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('fetch/trinity/summary_data')

    opts.bus.inQueueData = [
      sampleMappings.in0
    ]
  })

  describe('#handle', function () {
    it('successfully transforms the response from trinity into the expected payload for trinity-summary-data queue', async function () {
      const successResponse = fs.readFileSync('./test/integration/bots/fetch/trinity/summary_data/mock_responses/success.xml', 'utf8')
      const requestBody = `<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:trin="http://trinitysoft.net/">
   <soap:Header/>
   <soap:Body>
      <trin:RunCommand>
         <trin:Token>test-token</trin:Token>
         <trin:Context>NEVETICA</trin:Context>
         <trin:DealerID>1234</trin:DealerID>
         <trin:XMLString><![CDATA[<?xml version="1.0" encoding="utf-8"?><COMMANDREQUEST><COMMANDS numcommands="1"><COMMAND><COMMANDNAME>REALTIMEVOLUME</COMMANDNAME><ARGUMENTS numargs="1"><ARGUMENT><ARGUME
NTNAME>PERIOD</ARGUMENTNAME><ARGUMENTVALUE>CURRENT</ARGUMENTVALUE></ARGUMENT></ARGUMENTS></COMMAND></COMMANDS></COMMANDREQUEST>]]></trin:XMLString>
      </trin:RunCommand>
   </soap:Body>
</soap:Envelope>`

      opts.nock('http://localhost')
        .post('/FirestormWebServices/FirestormMobileWS.asmx', requestBody)
        .reply(200, successResponse)
        // .log(console.log)

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.deepEqual(out0, sampleMappings.out0)
    })

    it('handles a response where a valid Dealer was not found in Firestorm', async () => {
      const failResponse = fs.readFileSync('./test/integration/bots/fetch/trinity/summary_data/mock_responses/no-record-found.xml', 'utf8')
      const requestBody = `<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:trin="http://trinitysoft.net/">
   <soap:Header/>
   <soap:Body>
      <trin:RunCommand>
         <trin:Token>test-token</trin:Token>
         <trin:Context>NEVETICA</trin:Context>
         <trin:DealerID>1234</trin:DealerID>
         <trin:XMLString><![CDATA[<?xml version="1.0" encoding="utf-8"?><COMMANDREQUEST><COMMANDS numcommands="1"><COMMAND><COMMANDNAME>REALTIMEVOLUME</COMMANDNAME><ARGUMENTS numargs="1"><ARGUMENT><ARGUME
NTNAME>PERIOD</ARGUMENTNAME><ARGUMENTVALUE>CURRENT</ARGUMENTVALUE></ARGUMENT></ARGUMENTS></COMMAND></COMMANDS></COMMANDREQUEST>]]></trin:XMLString>
      </trin:RunCommand>
   </soap:Body>
</soap:Envelope>`

      opts.nock('http://localhost')
        .post('/FirestormWebServices/FirestormMobileWS.asmx', requestBody)
        .reply(200, failResponse)
        // .log(console.log)

      await bot.handle(opts.event, opts.context)

      assert(true)
    })

    it('handles a response where row 2 is an empty string', async () => {
      const successResponse = fs.readFileSync('./test/integration/bots/fetch/trinity/summary_data/mock_responses/second-row-empty.xml', 'utf8')
      const requestBody = `<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:trin="http://trinitysoft.net/">
   <soap:Header/>
   <soap:Body>
      <trin:RunCommand>
         <trin:Token>test-token</trin:Token>
         <trin:Context>NEVETICA</trin:Context>
         <trin:DealerID>1234</trin:DealerID>
         <trin:XMLString><![CDATA[<?xml version="1.0" encoding="utf-8"?><COMMANDREQUEST><COMMANDS numcommands="1"><COMMAND><COMMANDNAME>REALTIMEVOLUME</COMMANDNAME><ARGUMENTS numargs="1"><ARGUMENT><ARGUME
NTNAME>PERIOD</ARGUMENTNAME><ARGUMENTVALUE>CURRENT</ARGUMENTVALUE></ARGUMENT></ARGUMENTS></COMMAND></COMMANDS></COMMANDREQUEST>]]></trin:XMLString>
      </trin:RunCommand>
   </soap:Body>
</soap:Envelope>`

      opts.nock('http://localhost')
        .post('/FirestormWebServices/FirestormMobileWS.asmx', requestBody)
        .reply(200, successResponse)
        // .log(console.log)

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      // Ensure time it's the same for automatic generated dates
      sampleMappings.out0ForEmptyRow2.PeriodStartDate = out0.PeriodStartDate
      sampleMappings.out0ForEmptyRow2.PeriodEndDate = out0.PeriodEndDate
      assert.deepEqual(out0, sampleMappings.out0ForEmptyRow2)
    })
  })
}
