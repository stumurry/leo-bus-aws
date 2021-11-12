'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  const sampleInput0 = {
    icentris_client: 'listenuniversity',
    DealershipId: '1235',
    DealerID: '4568',
    CurrentPeriodPV: '501',
    CurrentPeriodGV: '701',
    CommissionableVolume: '78',
    CurrentPeriodCustomerPV: '101',
    GVWithMVR: '124',
    BCQLegs: '124',
    RPCLegs: '124',
    ADLegs: '124',
    NDLegs: '124',
    VPLegs: '124',
    NewGenq: '124',
    RankID: '2',
    RankDescription: 'Tri-state Chief',
    PaidRankID: '2',
    PaidRankDescription: 'Pope',
    PeriodID: '1235',
    PeriodDescription: '2Q 2019',
    PeriodTypeID: 3,
    PeriodTypeDescription: 'Quarterly'
  }

  const sampleInput1 = {
    icentris_client: 'nevetica',
    DealershipID: '1235',
    DealerID: '4568',
    CurrentPeriodPV: '502',
    CurrentPeriodGV: '702',
    CommissionableVolume: '79',
    CurrentPeriodCustomerPV: '101',
    GVWithMVR: '124',
    BCQLegs: '124',
    RPCLegs: '124',
    ADLegs: '124',
    NDLegs: '124',
    VPLegs: '124',
    IsBCQ: 0,
    NewGenq: '124',
    LifetimeDealershipTypeID: '2',
    CurrMonthLifetimeRank: 'Tri-state Chief',
    CurrentDealershipTypeID: '2',
    CurrMonthPaidRank: 'Pope',
    PeriodID: '1235',
    PeriodDescription: '2Q 2019',
    PeriodTypeID: 2,
    PeriodTypeDescription: 'Monthly',
    PeriodStartDate: '1/1/2019 12:00:00 AM',
    PeriodEndDate: '1/31/2019 11:59:59 PM'
  }

  const sampleInput2 = {
    icentris_client: 'nevetica',
    DealershipID: '12356',
    DealerID: '45689',
    CurrentPeriodPV: '502',
    CurrentPeriodGV: '702',
    CommissionableVolume: '80',
    CurrentPeriodCustomerPV: '101',
    GVWithMVR: '124',
    BCQLegs: '124',
    RPCLegs: '124',
    ADLegs: '124',
    NDLegs: '124',
    VPLegs: '124',
    IsBCQ: '125',
    NewGenq: '124',
    LifetimeDealershipTypeID: '2',
    CurrMonthLifetimeRank: 'Tri-state Chief',
    CurrentDealershipTypeID: '2',
    CurrMonthPaidRank: 'Pope',
    PeriodID: '1235',
    PeriodDescription: '2Q 2019',
    PeriodType: 'Weekly'
  }

  const sampleInput3 = {
    icentris_client: 'nevetica',
    DealershipID: '12356',
    DealerID: '45689',
    CurrentPeriodPV: '502',
    CurrentPeriodGV: '702',
    CommissionableVolume: '80',
    CurrentPeriodCustomerPV: '101',
    GVWithMVR: '124',
    BCQLegs: '124',
    RPCLegs: '124',
    ADLegs: '124',
    NDLegs: '124',
    VPLegs: '124',
    IsBCQ: -1,
    NewGenq: '124',
    LifetimeDealershipTypeID: '2',
    CurrMonthLifetimeRank: 'Tri-state Chief',
    CurrentDealershipTypeID: '2',
    CurrMonthPaidRank: 'Pope',
    PeriodID: '1235',
    PeriodDescription: '2Q 2019',
    PeriodType: 'Weekly'
  }

  const expectedOutput0 = {
    icentris_client: 'listenuniversity',
    client_user_id: 'd1235',
    tree_user_id: null,
    period_id: null,
    period_type_id: null,
    rank_id: null,
    paid_rank_id: null,
    personal_volume: '501',
    group_volume: '701',
    commissionable_volume: '78',
    allowed_volume: '124',
    rank: {
      client_level: '2',
      name: 'Tri-state Chief'
    },
    paid_rank: {
      client_level: '2',
      name: 'Pope'
    },
    period: {
      id: '1235',
      description: '2Q 2019',
      type: {
        id: 3,
        description: 'Quarterly'
      }
    },
    personally_sponsored_rankholders: {
      all_active: '124',
      regional_pet_consultant: '124',
      area_director: '124',
      national_director: '124',
      vice_president: '124'
    },
    extra: {
      dealer_id: '4568',
      dealership_id: '1235',
      customer_personal_volume: '101',
      new_genq: '124'
    }
  }

  const expectedOutput1 = {
    icentris_client: 'nevetica',
    client_user_id: 'd1235',
    tree_user_id: null,
    period_id: null,
    period_type_id: null,
    rank_id: null,
    paid_rank_id: null,
    personal_volume: '502',
    group_volume: '702',
    allowed_volume: '124',
    commissionable_volume: '79',
    rank: {
      client_level: '2',
      name: 'Tri-state Chief'
    },
    paid_rank: {
      client_level: '2',
      name: 'Pope'
    },
    period: {
      id: '1235',
      description: '2Q 2019',
      start_date: '1/1/2019 12:00:00 AM',
      end_date: '1/31/2019 11:59:59 PM',
      type: {
        id: 2,
        description: 'Monthly'
      }
    },
    personally_sponsored_rankholders: {
      all_active: '124',
      regional_pet_consultant: '124',
      area_director: '124',
      national_director: '124',
      vice_president: '124'
    },
    extra: {
      dealer_id: '4568',
      dealership_id: '1235',
      qualified: '0',
      customer_personal_volume: '101',
      new_genq: '124'
    }
  }

  const expectedOutput2 = {
    icentris_client: 'nevetica',
    client_user_id: 'd12356',
    tree_user_id: null,
    period_id: null,
    period_type_id: null,
    rank_id: null,
    paid_rank_id: null,
    personal_volume: '502',
    group_volume: '702',
    allowed_volume: '124',
    commissionable_volume: '80',
    rank: {
      client_level: '2',
      name: 'Tri-state Chief'
    },
    paid_rank: {
      client_level: '2',
      name: 'Pope'
    },
    period: {
      id: '1235',
      description: '2Q 2019',
      type: {
        id: 1,
        description: 'Weekly'
      }
    },
    personally_sponsored_rankholders: {
      all_active: '124',
      regional_pet_consultant: '124',
      area_director: '124',
      national_director: '124',
      vice_president: '124'
    },
    extra: {
      dealer_id: '45689',
      dealership_id: '12356',
      qualified: '125',
      customer_personal_volume: '101',
      new_genq: '124'
    }
  }

  const expectedOutput3 = {
    icentris_client: 'nevetica',
    client_user_id: 'd12356',
    tree_user_id: null,
    period_id: null,
    period_type_id: null,
    rank_id: null,
    paid_rank_id: null,
    personal_volume: '502',
    group_volume: '702',
    allowed_volume: '124',
    commissionable_volume: '80',
    rank: {
      client_level: '2',
      name: 'Tri-state Chief'
    },
    paid_rank: {
      client_level: '2',
      name: 'Pope'
    },
    period: {
      id: '1235',
      description: '2Q 2019',
      type: {
        id: 1,
        description: 'Weekly'
      }
    },
    personally_sponsored_rankholders: {
      all_active: '124',
      regional_pet_consultant: '124',
      area_director: '124',
      national_director: '124',
      vice_president: '124'
    },
    extra: {
      dealer_id: '45689',
      dealership_id: '12356',
      qualified: -1,
      customer_personal_volume: '101',
      new_genq: '124'
    }
  }

  beforeEach(async () => {
    bot = opts.getBot('load/trinity/summary_data')
  })

  describe('#handle', function () {
    beforeEach(() => {
      opts.bus.inQueueData = [
        sampleInput0,
        sampleInput1,
        sampleInput2,
        sampleInput3
      ]
    })

    it('puts proper data on outQueue', async function () {
      this.timeout(5000)

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 4)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload
      const out2 = opts.bus.outQueueData[2].payload
      const out3 = opts.bus.outQueueData[3].payload

      assert.deepEqual(out0, expectedOutput0)
      assert.deepEqual(out1, expectedOutput1)
      assert.deepEqual(out2, expectedOutput2)
      assert.deepEqual(out3, expectedOutput3)
    })
  })
}
