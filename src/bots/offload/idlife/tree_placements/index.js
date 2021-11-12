'use strict'

const leo = require('leo-sdk')
const ls = leo.streams
const async = require('async')

const client = require('leo-connector-mysql').connect({
  host: 'localhost',
  user: 'root',
  port: 3306,
  database: 'icentris',
  password: 'a',
  connectionLimit: 10
})

exports.handler = function (event, context, callback) {
  const ID = context.botId

  let lastRecord = null
  let count = 0
  const stats = ls.stats(ID, 'unileveltree')
  ls.pipe(ls.fromLeo(ID, 'unileveltree', {
    start: 'z/2018/03/28/11/11/1522235484020'
  }), stats, ls.through((obj, done) => {
    count++
    lastRecord = obj.payload
    done(null)
  }), ls.devnull(), err => {
    console.log(err)

    // we had an event to load
    if (lastRecord) {
      let loadFile
      if (count > 1) { // Then we might as well just do the full change set
        loadFile = lastRecord.entire
      } else {
        loadFile = lastRecord.changeSet
      }
      const tasks = []
      let i = 0
      tasks.push(done => client.query('Start Transaction', done))
      tasks.push(done => {
        console.time('LOADING RECORDS')
        ls.pipe(ls.fromS3(loadFile), ls.parse(), ls.through((obj, done) => {
          done(null, {
            id: ++i,
            tree_user_id: obj[0],
            upline_id: obj[1],
            lft: obj[4],
            rgt: obj[5],
            position: obj[2],
            level: obj[3]
          })
        }), client.streamToTableBatch('tree_placements_steve', {
          // useReplaceInto: true,
          records: 70000
        }), err => {
          console.log(err)
          done(err)
        })
      })
      tasks.push(done => client.query('Commit', done))
      async.series(tasks, err => {
        console.timeEnd('LOADING RECORDS')
        callback(err)
      })
    } else {
      callback()
    }
  })
}
