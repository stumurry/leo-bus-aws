'use strict'

module.exports = (opts) => {
  const rewire = require('rewire')
  const maxcdc = rewire('../../../libs/maxcdc')
  const assert = opts.assert
  const sinon = opts.sinon
  const stream = require('stream')
  const { promisify } = require('util')
  const split2 = require('split2')

  const maxCdcCfg = {
    host: 'http://wv.local.ml-apis.vibeoffice.com/',
    domain: 0,
    server_id: 1,
    password: 'password',
    port: 4001,
    user: 'icentrismax'
  }

  const user = 'icentrismax'
  const password = 'maxpwd'
  const checkpoints = {
    'test.contacts': {
      sequence: 1
    },
    'test.contacts2': {
      sequence: 1
    }
  }
  describe(('#maxscale cdc connector'), function () {
    describe(('filterStarterPayloadResponses'), function () {
      it('should test good maxscale cdc response', async function () {
        const table = 'test.contacts'
        const input = 'OK\nOK\nOK\n{"Hello":"World"}\n'

        const reader = new stream.Readable({
          read () { }
        })

        const current = []
        const writer = () => {
          return new stream.Writable({
            write: function (chunk, encoding, next) {
              current.push(chunk.toString())
              next()
            }
          })
        }

        reader.push(input)
        reader.push(null)

        const pipelineAsync = promisify(stream.pipeline)
        const mockSocket = {}
        await (pipelineAsync(
          reader,
          split2(),
          maxcdc.filterStarterPayloadResponses(table, mockSocket),
          writer()
        )).then(done => {
          const expected = [JSON.stringify({ Hello: 'World', table: table })]
          assert.deepEqual(current, expected)
        })
      })

      it('should test for bad response', async function () {
        const table = 'test.contacts'
        const input = 'ERR something bad happened'

        const reader = new stream.Readable({
          read () { }
        })

        const current = []
        const writer = () => {
          return new stream.Writable({
            write: function (chunk, encoding, next) {
              current.push(chunk.toString())
              next()
            }
          })
        }

        reader.push(input)
        reader.push(null)

        const pipelineAsync = promisify(stream.pipeline)
        const mockSocket = {
          end: () => { }
        }
        try {
          await pipelineAsync(
            reader,
            split2(),
            maxcdc.filterStarterPayloadResponses(table, mockSocket),
            writer()
          )
          assert.fail('no exception was thrown')
        } catch (e) {
          assert.equal(e, 'ERR something bad happened')
        }
      })
    })

    it('should stream changes', async function () {
      const mockPipeline = (table, checkpoints, maxCdcCfg) => {
        const resp = {
          domain: 0,
          server_id: 1,
          sequence: 17,
          event_number: 1,
          timestamp: 1604530022,
          event_type: 'insert',
          id: 1,
          username: 'Peter',
          mail: null,
          lastupdate: null,
          table: table
        }
        return Promise.resolve([resp])
      }

      maxcdc.__set__('createPipeline', mockPipeline)

      let current = []
      let count = 0
      const writer = () => {
        return new stream.Writable({
          objectMode: true,
          write: function (chunk, encoding, next) {
            ++count
            current = chunk
            next()
          }
        })
      }

      const expected = [{
        domain: 0,
        server_id: 1,
        sequence: 17,
        event_number: 1,
        timestamp: 1604530022,
        event_type: 'insert',
        id: 1,
        username: 'Peter',
        mail: null,
        lastupdate: null,
        table: 'test.contacts'
      },
      {
        domain: 0,
        server_id: 1,
        sequence: 17,
        event_number: 1,
        timestamp: 1604530022,
        event_type: 'insert',
        id: 1,
        username: 'Peter',
        mail: null,
        lastupdate: null,
        table: 'test.contacts2'
      }]

      const tables = {
        'test.contacts': {
          operation: ['update', 'insert']
        },
        'test.contacts2': {
          operation: ['update', 'insert']
        }
      }

      const pipelineAsync = promisify(stream.pipeline)
      await (pipelineAsync(
        maxcdc.streamChanges(tables, checkpoints, maxCdcCfg),
        writer()
      ))

      assert(count === 1, `Count should be 1. Found ${count}`)
      assert.deepEqual(current, expected)
    })

    it('getCheckpoint', function () {
      const checkpoint = {}

      let checkpointCallback = ''
      const noCkptCb = (table) => {
        checkpointCallback = table
      }

      const table = 'test.contacts'
      const cp = maxcdc.getCheckpoint(table, checkpoint, maxCdcCfg, noCkptCb)
      const expected = { domain: 0, server_id: 1, sequence: 0, event_id: 0 }
      assert.deepEqual(cp, expected)
      assert.equal(checkpointCallback, table)
    })

    it('createSocket', function () {
      const table = 'test.contacts'
      const net = require('net')
      const mockSocket = {
        setTimeout: sinon.spy()
      }
      sinon.stub(net, 'createConnection')
        .callsFake((port, hostname) => mockSocket)

      const expectedMockSocket = maxcdc.createSocket(table, checkpoints, maxCdcCfg)

      assert(mockSocket.setTimeout.calledOnce)
      assert.deepEqual(mockSocket, expectedMockSocket)
    })

    it('buildAuthRequest', function () {
      const current = maxcdc.buildAuthRequest(user, password)
      const expected = '6963656e747269736d61783a4a8bbec273435b777d0f3d71441e173f8968e2f1'
      assert.equal(current, expected)
    })

    it('writeStarterPayloads', async function () {
      const table = 'test.contacts'
      const cp = checkpoints[table]
      const domain = cp.domain
      const server = cp.server_id
      const sequence = cp.sequence

      const auth = maxcdc.buildAuthRequest(maxCdcCfg.user, maxCdcCfg.password)
      const requestData = `REQUEST-DATA ${table} ${domain}-${server}-${sequence + 1}`
      const expected = [auth, 'REGISTER UUID=XXX-YYY_YYY, TYPE=JSON', requestData]
      const current = []
      const socket = {
        write: (data) => {
          current.push(data)
        }
      }
      await maxcdc.writeStarterPayloads(socket, table, checkpoints, maxCdcCfg)
      assert.deepEqual(current, expected)
    })

    it('createPipeline', async function () {
      const table = 'test.contacts'
      const input = 'OK\nOK\nOK\n{"Hello":"World"}\n{"Hello":"World"}\n'

      const expected = [
        {
          Hello: 'World',
          table: 'test.contacts'
        },
        {
          Hello: 'World',
          table: 'test.contacts'
        }
      ]

      const mockSocket = new stream.Readable({
        read () { }
      })

      mockSocket.push(input)
      mockSocket.push(null)

      maxcdc.__set__('createSocket', (table, domain, server, sequence, user, pass) => mockSocket)

      const current = await maxcdc.createPipeline(table, checkpoints, maxCdcCfg)
      assert.deepEqual(current, expected)
    })

    it('formatPayload', async function () {
      const tables = {
        'test.contacts': {
          allowed_event_types: ['update', 'insert']
        },
        'test.contacts2': {
          allowed_event_types: ['update', 'insert']
        }
      }

      const readable = new stream.Readable({ objectMode: true, read () { } })
      const input = [
        { domain: 0, server_id: 3000, sequence: 17, event_number: 1, timestamp: 1604530022, event_type: 'insert', id: 1, username: 'Peter', mail: null, lastupdate: null, table: 'test.contacts' },
        { domain: 0, server_id: 3000, sequence: 18, event_number: 1, timestamp: 1604530022, event_type: 'insert', id: 2, username: 'Paul', mail: null, lastupdate: null, table: 'test.contacts' },
        { domain: 0, server_id: 3000, sequence: 18, event_number: 1, timestamp: 1604530022, event_type: 'insert', id: 1, username: 'Mary', mail: null, lastupdate: null, table: 'test.contacts2' },
        { domain: 0, server_id: 3000, sequence: 19, event_number: 1, timestamp: 1604530022, event_type: 'insert', id: 2, username: 'Joseph', mail: null, lastupdate: null, table: 'test.contacts2' }
      ]
      readable.push(input)
      readable.push(null) // End stream

      const current = []
      const writable = new stream.Writable({ objectMode: true })
      writable._write = (object, encoding, d) => {
        current.push(object)
        d()
      }

      const lastCheckpoint = {
        'test.contacts': { domain: 0, server_id: 3000, sequence: 18 },
        'test.contacts2': { domain: 0, server_id: 3000, sequence: 19 }
      }

      const expected = [
        {
          payload: {
            insert: {
              test: {
                contacts: [
                  2,
                  1
                ],
                contacts2: [
                  2,
                  1
                ]
              }
            }
          },
          correlation_id: {
            source: 'system:maxscale-ec2',
            start: JSON.stringify(lastCheckpoint),
            end: JSON.stringify(lastCheckpoint),
            units: 1
          }
        }
      ]

      const pipelineAsync = promisify(stream.pipeline)
      await pipelineAsync(
        readable,
        maxcdc.formatPayload(tables, checkpoints),
        writable
      )

      assert.deepEqual(current, expected)
    })
  })
}
