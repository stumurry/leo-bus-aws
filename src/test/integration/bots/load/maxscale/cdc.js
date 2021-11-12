'use strict'

module.exports = (opts) => {
  const stream = require('stream')
  const assert = opts.assert
  let bot
  const { promisify } = require('util')

  const database = 'pyr-plexus-prd'
  const table = 'contacts'

  before(() => {
    opts.event.icentris_client = 'bluesun'
    opts.event.tables = [
      'contacts'
    ]
  })

  after(() => {
    delete opts.event.icentris_client
  })

  beforeEach((done) => {
    const pp = async () => {
      bot = opts.getBot('load/maxscale')
      bot.useS3 = false

      opts.event.icentris_client = 'bluesun'
    }

    pp().then(done).catch(done)
  })

  describe('#handle', function () {
    it.only('sortS3', (done) => {
      const checkpoint = 'contacts/pyr-plexus-prd/contacts-2834-2117.json'
      const bucketList = [
        'contacts/',
        'contacts/pyr-plexus-prd/',
        'contacts/pyr-plexus-prd/contacts-2835-2.json',
        'contacts/pyr-plexus-prd/contacts-2834-2116.json',
        'contacts/pyr-plexus-prd/contacts-2834-2118.json',
        'contacts/pyr-plexus-prd/contacts-2835-1.json',
        'tree_leads/pyr-plexus-prd/tree_leads-2836-89.json',
        'contacts/pyr-plexus-prd/contacts-2834-2117.json'
      ]
      const actual = bot.sortS3(bucketList, checkpoint, database, table)
      const expected = [
        {
          sequence: 2834,
          event_id: 2118,
          fileName: 'contacts/pyr-plexus-prd/contacts-2834-2118.json',
          database: database,
          table: table
        },
        {
          sequence: 2835,
          event_id: 1,
          fileName: 'contacts/pyr-plexus-prd/contacts-2835-1.json',
          database: database,
          table: table
        },
        {
          sequence: 2835,
          event_id: 2,
          fileName: 'contacts/pyr-plexus-prd/contacts-2835-2.json',
          database: database,
          table: table
        }
      ]
      assert.deepEqual(actual, expected)

      done()
    })

    it('processMaxScale', (done) => {
      const checkpoint = 'contacts/pyr-plexus-prd/contacts-2834-2117.json'
      const bucketList = [
        'contacts/',
        'contacts/pyr-plexus-prd/',
        'contacts/pyr-plexus-prd/contacts-2834-2116.json',
        'contacts/pyr-plexus-prd/contacts-2834-2117.json',
        'contacts/pyr-plexus-prd/contacts-2834-2118.json',
        'contacts/pyr-plexus-prd/contacts-2835-1.json',
        'contacts/pyr-plexus-prd/contacts-2835-2.json',
        'tree_leads/pyr-plexus-prd/tree_leads-2836-89.json'
      ]

      const actual = []
      const writer = () => {
        return new stream.Writable({
          objectMode: true,
          write: function (chunk, encoding, next) {
            actual.push(chunk)
            next()
          }
        })
      }
      const reader = new stream.Readable({
        objectMode: true,
        read () { }
      })
      reader.push(checkpoint)
      reader.push(null)

      bot.listObjects = async (params) => {
        return bucketList
      }

      bot.getS3Object = async (params) => {
        const data = [{
          domain: 0,
          server_id: 2088467825,
          sequence: getSequence(),
          event_number: 2116,
          timestamp: 1615223638,
          event_type: 'update_after',
          id: getId(),
          first_name: 'Nathan',
          last_name: 'Oconnor-updated'
        },
        {
          domain: 0,
          server_id: 2088467825,
          sequence: getSequence(),
          event_number: 2116,
          timestamp: 1615223638,
          event_type: 'update_after',
          id: getId(),
          first_name: 'Nathan',
          last_name: 'Oconnor-updated'
        }]
        return data
      }

      let idCount = 0
      const getId = () => {
        return ++idCount
      }
      let seqCount = 0
      const getSequence = () => {
        return ++seqCount
      }

      const pipelineAsync = promisify(stream.pipeline)
      pipelineAsync(
        reader,
        bot.processMaxScale('maxscale-cdc-dev', database, table),
        writer()
      ).then(s => {
        try {
          const expected = [{
            payload: [
              { update_after: { 'pyr-plexus-prd': { contacts: [1, 2, 3, 4, 5, 6] } } }],
            start: 'contacts/pyr-plexus-prd/contacts-2834-2117.json',
            end: 'contacts/pyr-plexus-prd/contacts-2835-2.json'
          }]
          assert.deepEqual(actual, expected)
          done()
        } catch (e) {
          done(e)
        }
      }).catch(e => {
        console.log(e)
        done(e)
      })
    })

    it.only('convertNdjson', (done) => {
      const s1 = { domain: 0, server_id: 2088467825, sequence: 3138, event_number: 2, timestamp: 1615308491, event_type: 'update_after', id: 1, first_name: 'John', last_name: 'Smith' }
      const s2 = { domain: 0, server_id: 2088467825, sequence: 3138, event_number: 2, timestamp: 1615308491, event_type: 'update_after', id: 1, first_name: 'John', last_name: 'Smith' }
      const ndjson = `${JSON.stringify(s1)}\n${JSON.stringify(s2)}\r\n`
      const actual = bot.convertNdjson(ndjson)
      const expected = [
        {
          domain: 0,
          server_id: 2088467825,
          sequence: 3138,
          event_number: 2,
          timestamp: 1615308491,
          event_type: 'update_after',
          id: 1,
          first_name: 'John',
          last_name: 'Smith'
        },
        {
          domain: 0,
          server_id: 2088467825,
          sequence: 3138,
          event_number: 2,
          timestamp: 1615308491,
          event_type: 'update_after',
          id: 1,
          first_name: 'John',
          last_name: 'Smith'
        }
      ]
      assert.deepEqual(actual, expected)
      done()
    })

    it('updateCheckpoint', (done) => {
      const actual = []
      const writer = () => {
        return new stream.Writable({
          objectMode: true,
          write: function (chunk, encoding, next) {
            actual.push(chunk)
            next()
          }
        })
      }
      const reader = new stream.Readable({
        objectMode: true,
        read () { }
      })
      reader.push({
        payload: [{ update_after: { 'pyr-bluesun-prd': { contacts: [1, 2, 3, 4, 5, 6, 7, 8] } } }],
        start: 'contacts/pyr-plexus-prd/contacts-2835-1.json',
        end: 'contacts/pyr-plexus-prd/contacts-2835-2.json'
      })
      reader.push(null) // Terminate so it doesn't hang
      const pipelineAsync = promisify(stream.pipeline)
      pipelineAsync(
        reader,
        bot.updateCheckpoint(),
        writer()
      ).then(s => {
        try {
          const expected = [
            {
              correlation_id: {
                source: 'system:maxscale-ec2',
                units: 1,
                start: 'contacts/pyr-plexus-prd/contacts-2835-1.json',
                end: 'contacts/pyr-plexus-prd/contacts-2835-2.json'
              },
              payload: [{ update_after: { 'pyr-bluesun-prd': { contacts: [1, 2, 3, 4, 5, 6, 7, 8] } } }]
            }
          ]
          assert.deepEqual(actual, expected)
          done()
        } catch (e) {
          done(e)
        }
      }).catch(e => {
        console.log(e)
        done(e)
      })
    })

    it.only('filterJsonFiles', (done) => {
      const bucketList = [
        'contacts/',
        'contacts/pyr-plexus-prd/',
        'contacts/pyr-plexus-prd/contacts-2834-2116.json',
        'contacts/pyr-plexus-prd/contacts-2834-2117.json',
        'contacts/pyr-plexus-prd/contacts-2834-2118.json',
        'contacts/pyr-plexus-prd/contacts-2835-1.json',
        'contacts/pyr-plexus-prd/contacts-2835-2.json',
        'tree_leads/pyr-plexus-prd/tree_leads-2836-89.json'
      ]
      const actual = bot.filterJsonFiles(bucketList, database, table)

      const expected = [
        'contacts/pyr-plexus-prd/contacts-2834-2116.json',
        'contacts/pyr-plexus-prd/contacts-2834-2117.json',
        'contacts/pyr-plexus-prd/contacts-2834-2118.json',
        'contacts/pyr-plexus-prd/contacts-2835-1.json',
        'contacts/pyr-plexus-prd/contacts-2835-2.json'
      ]
      assert.deepEqual(actual, expected)
      done()
    })

    it.only('getCheckpointFromFilename', (done) => {
      const checkpoint = 'contacts/pyr-plexus-prd/contacts-2834-2117.json'
      const actual = bot.getCheckpointFromFileName(checkpoint, database, table)
      assert.deepEqual(actual, {
        fileName: checkpoint,
        sequence: 2834,
        event_id: 2117,
        database: database,
        table: table
      })
      done()
    })
  })
}
