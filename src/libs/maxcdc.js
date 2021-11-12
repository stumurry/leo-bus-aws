const crypto = require('crypto')
const split2 = require('split2')
const through2 = require('through2')
const net = require('net')
const stream = require('stream')
// const host = 'maxscale'
// const port = 4001
// const user = 'icentrismax'
// const pass = 'maxpwd'
const { promisify } = require('util')
const utils = require('./utils')
const Log = require('./log')
/***
 * table - The name of the cdc maxscale table to track off of.
 * checkpoints - sequence number and other information to keep track of where maxscale should read.
 * maxCdcCfg - Github configuration properties containing maxscale server information.
 * noCkptCb - No Checkpoint Callback. Executes this function if there is no checkpoint associated
 * with this table.
 */
const getCheckpoint = (table, checkpoints, maxCdcCfg, noCkptCb) => {
  // Maxcdc server (ec2 instance) will contain multiple RDS replicas, one for every client,
  // so be sure to set the client's domain and server id located inside config file.
  if (!Number.isInteger(maxCdcCfg.domain)) throw new Error('domain missing from config. Please reference maxcdc server or documentaion.')
  if (!Number.isInteger(maxCdcCfg.server_id)) throw new Error('server_id missing from config. Please reference maxcdc server or documentaion.')
  if (!maxCdcCfg.host) throw new Error('host missing from config. Please reference maxcdc server or documentaion.')
  if (!maxCdcCfg.user) throw new Error('user missing from config. Please reference maxcdc server or documentaion.')
  if (!maxCdcCfg.password) throw new Error('password missing from config. Please reference maxcdc server or documentaion.')

  if (!checkpoints[table]) {
    noCkptCb(table)
    checkpoints[table] = {
      domain: maxCdcCfg.domain,
      server_id: maxCdcCfg.server_id,
      sequence: 0,
      event_id: 0
    }
  }

  return checkpoints[table]
}

const buildAuthRequest = (user, pass) => {
  let authStr = Buffer.from(`${user}:`, 'utf8').toString('hex')
  const shasum = crypto.createHash('sha1')
  shasum.update(pass)
  authStr += shasum.digest('hex')
  return authStr
}

const writeStarterPayloads = async (socket, table, checkpoints, maxCdcCfg, noCkptCb) => {
  const cp = getCheckpoint(table, checkpoints, maxCdcCfg, noCkptCb)
  await socket.write(buildAuthRequest(maxCdcCfg.user, maxCdcCfg.password))
  await new Promise(resolve => setTimeout(resolve, 500))
  await socket.write('REGISTER UUID=XXX-YYY_YYY, TYPE=JSON')
  await new Promise(resolve => setTimeout(resolve, 500))
  const requestData = `REQUEST-DATA ${table} ${cp.domain}-${cp.server_id}-${cp.sequence + 1}`
  Log.info('maxcdc', requestData)
  await socket.write(requestData)
}

const createSocket = (table, checkpoints, maxCdcCfg, noCkptCb) => {
  const socket = net.createConnection(maxCdcCfg.port, maxCdcCfg.host, async () => {
    await writeStarterPayloads(socket, table, checkpoints, maxCdcCfg, noCkptCb)
  })

  socket.setTimeout(2000, () => {
    console.log('Socket timeout reached. Closing socket now.')
    socket.end()
  })

  return socket
}

const filterStarterPayloadResponses = (table, socket) => {
  let count = 0
  return through2((chunk, enc, callback) => {
    if (chunk.toString().includes('ERR')) {
      socket.end()
      callback(chunk.toString())
    }
    if (++count > 3) {
      const o = JSON.parse(chunk.toString())
      Object.assign(o, {
        table: table
      })
      callback(null, JSON.stringify(o))
    } else {
      callback(null, null)
    }
  })
}

const createPipeline = (table, checkpoints, maxCdcCfg, noCkptCb) => {
  const current = []
  const writer = () => {
    return new stream.Writable({
      write: function (chunk, encoding, next) {
        current.push(JSON.parse(chunk.toString()))
        next()
      }
    })
  }

  const socket = createSocket(table, checkpoints, maxCdcCfg, noCkptCb)
  const pipelineAsync = promisify(stream.pipeline)
  return (pipelineAsync(
    socket,
    split2(),
    filterStarterPayloadResponses(table, socket),
    writer()
  )).then(() => {
    return current
  })
}

const streamChanges = (tables, checkpoints, maxCdcCfg, noCkptCb) => {
  if (!tables || !typeof (tables) === 'object') throw new Error('tables is missing or must be an object')
  if (!checkpoints || !typeof (checkpoints) === 'object') throw new Error('checkpoints is missing and must be an object')
  if (!maxCdcCfg || !typeof (maxCdcCfg) === 'object') throw new Error('maxCdcCfg is missing amd must be an object')

  const reader = new stream.Readable({
    objectMode: true,
    read () { }
  })

  const promises = Object.keys(tables).map((t) => {
    return createPipeline(t, checkpoints, maxCdcCfg, noCkptCb)
  })

  Promise.all(promises).then(e => {
    const acc = []
    e.forEach(ee => ee.forEach(eee => acc.push(eee)))
    if (acc.length > 0) {
      reader.push(acc)
    }
    reader.push(null)
  }).catch(err => {
    console.log('There was an error', err)
  })

  return reader
}

const formatPayload = (tables, checkpoints) => {
  if (!tables) throw new Error('Table metadata is missing.')
  if (!checkpoints) throw new Error('checkpoints is missing.')
  return through2.obj((chunk, enc, callback) => {
    const sortBySequenceAndTable = chunk
      .sort((a, b) => {
        if (a.sequence < b.sequence) {
          return 1
        } else if (a.sequence > b.sequence) {
          return -1
        }
        return 0
      })
      .sort((a, b) => {
        if (a.table < b.table) {
          return -1
        } else if (a.table > b.table) {
          return 1
        }
        return 0
      })

    const groupByTable = utils.groupBy(sortBySequenceAndTable, 'table')

    const seq = {}
    Object.keys(groupByTable).forEach(k => {
      const tableGroup = groupByTable[k][0]
      seq[k] = {
        domain: tableGroup.domain,
        server_id: tableGroup.server_id,
        sequence: tableGroup.sequence
      }
    })

    const formattedPayload = chunk.reduce((acc, curr) => {
      const allowedEventTypes = tables[curr.table].allowed_event_types
      if (allowedEventTypes.indexOf(curr.event_type) > -1) {
        // Initialize payload keys if not exists.
        if (!acc[curr.event_type]) acc[curr.event_type] = {}
        const splits = curr.table.split('.')
        const schema = splits[0]
        const table = splits[1]
        if (!acc[curr.event_type][schema]) acc[curr.event_type][[schema]] = {}
        if (!acc[curr.event_type][schema][table]) acc[curr.event_type][schema][table] = []
        acc[curr.event_type][schema][table].push(curr.id)
      }
      return acc
    }, {})

    const event = {
      correlation_id: {
        source: 'system:maxscale-ec2',
        units: 1,
        start: JSON.stringify(seq),
        end: JSON.stringify(seq)
      }
    }

    if (Object.keys(formattedPayload).length === 0) {
      callback(null)
    } else {
      callback(null, Object.assign(event, { payload: formattedPayload }))
    }
  })
}

module.exports = {
  createSocket: createSocket,
  buildAuthRequest: buildAuthRequest,
  writeStarterPayloads: writeStarterPayloads,
  filterStarterPayloadResponses: filterStarterPayloadResponses,
  createPipeline: createPipeline,
  streamChanges: streamChanges,
  formatPayload: formatPayload,
  getCheckpoint: getCheckpoint

}
