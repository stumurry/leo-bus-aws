class TrinitySummaryData {
  constructor (opts) {
    opts = opts || {}
    this.icentris_client = opts.icentris_client || null
    this.client_user_id = opts.client_user_id || null
    this.tree_user_id = opts.tree_user_id || null
    this.period_id = opts.period_id || null
    this.period_type_id = opts.period_type_id || null
    this.rank_id = opts.rank_id || null
    this.paid_rank_id = opts.paid_rank_id || null
    this.rank = opts.rank || {
      id: null,
      description: null
    }
    this.paid_rank = opts.paid_rank || {
      id: null,
      description: null
    }
    this.period = opts.period || {
      id: null,
      description: null,
      type: {
        id: null,
        name: null
      }
    }
    this.personally_sponsored_rankholders = opts.period || {}
    this.personal_volume = opts.personal_volume || null
    this.group_volume = opts.group_volume || null
    this.extra = opts.extra || {}
  }
}

module.exports = TrinitySummaryData
