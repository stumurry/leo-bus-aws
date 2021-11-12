'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot

  before(async () => {
    opts.event.icentris_client = 'idlife'
    bot = opts.getBot('load/exigo/tree_node')
  })

  describe('#Tree Node', function () {
    it('should load exigo cdc changes using domainobject into queue', async function () {
      this.timeout(5000)
      opts.event = {
        icentris_client: 'idlife',
        table: 'UniLevelTree',
        fields: ['CustomerID', 'SponsorID', 'NestedLevel', 'Placement', 'Lft', 'Rgt'],
        ...opts.event
      }

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            UniLevelTree: [
              {
                CustomerID: 1
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      assert.strictEqual(opts.bus.outQueueData.length, 1)

      const payload = opts.bus.outQueueData[0].payload
      assert.strictEqual(payload.client_user_id, 1)
      assert.strictEqual(payload.level, 4)
    })

    it('should load exigo cdc using [insert] statements using the domainobject into queue', async function () {
      this.timeout(5000)
      opts.event = {
        icentris_client: 'idlife',
        table: 'UniLevelTree',
        fields: ['CustomerID', 'SponsorID', 'NestedLevel', 'Placement', 'Lft', 'Rgt'],
        ...opts.event
      }

      opts.bus.inQueueData = [{
        delete: {},
        insert: {
          idlife: {
            UniLevelTree: [
              {
                CustomerID: 1
              }
            ]
          }
        },
        update: {
          idlife: {
            UniLevelTree: [
              {
                CustomerID: 1
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)

      const out0 = opts.bus.outQueueData[0].payload
      const out1 = opts.bus.outQueueData[1].payload
      assert.strictEqual(opts.bus.outQueueData.length, 2)
      assert.strictEqual(out0.client_user_id, 1)
      assert.strictEqual(out1.client_user_id, 1)
    })

    it('should load exigo cdc changes using domainobject into queue for EnrollerTree', async function () {
      this.timeout(5000)
      opts.event = Object.assign(opts.event, {
        table: 'EnrollerTree',
        fields: ['CustomerID', 'EnrollerID', 'NestedLevel', 'Lft', 'Rgt']
      })

      opts.bus.inQueueData = [{
        delete: {},
        insert: {},
        update: {
          idlife: {
            EnrollerTree: [
              {
                CustomerID: 1
              }
            ]
          }
        }
      }]

      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.strictEqual(out0.type, 'sponsors')
      assert.strictEqual(out0.client_user_id, 1)
    })
  })
}
