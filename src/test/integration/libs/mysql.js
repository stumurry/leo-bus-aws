'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  const moment = opts.moment
  before(async () => {
    await opts.mysql.execute('DROP TABLE IF EXISTS force_users')
    await opts.mysql.execute(`CREATE TABLE force_users (
        id INT UNSIGNED NOT NULL PRIMARY KEY,
        \`name\` VARCHAR(100) NOT NULL,
        allegiance ENUM('Jedi', 'Sith') NULL,
        \`rank\` VARCHAR(100) NULL,
        status VARCHAR(50) NULL,
        trained_by INT UNSIGNED NULL,
        birth DATETIME NOT NULL,
        death DATETIME NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      ) ENGINE=Innodb`)

    await opts.mysql.execute('DROP TABLE IF EXISTS test')
    await opts.mysql.execute(`CREATE TABLE test (
      id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        \`title\` VARCHAR(100) NOT NULL,
        \`description\` VARCHAR(1000) NOT NULL
    )ENGINE=InnoDB`)
  })

  let forceUsers = []
  let tests = []
  beforeEach(async () => {
    forceUsers = [{
      id: 1,
      name: 'Darth Vader',
      allegiance: 'Sith',
      birth: '1977-05-25',
      death: '1983-05-25'
    }, {
      id: 2,
      name: 'Luke Skywalker',
      allegiance: 'Jedi',
      rank: 'Master',
      status: 'Unknown'
    }, {
      id: 3,
      name: 'Yoda',
      allegiance: 'Jedi',
      status: 'Ghost',
      birth: '1980-05-21'
    }, {
      id: 4,
      name: 'Darth Sidius',
      allegiance: 'Sith',
      status: 'In Hell'
    }]

    tests = [{
      title: 'Test 1',
      description: 'The first test'
    }]

    opts.mysql.execute('TRUNCATE TABLE force_users')
    opts.mysql.execute('TRUNCATE TABLE test')
  })

  describe('#streamToTable', function () {
    let stream
    beforeEach(async () => {
      stream = await opts.mysql.streamToTable('force_users', {
        useReplaceInto: true,
        event: opts.event
      })
    })

    it('should perform a successful insert', async () => {
      stream.write({ eid: 'z/', record: forceUsers[0] })

      return new Promise((resolve, reject) => {
        stream.end(async err => {
          if (err) reject(err)
          else {
            const vader = await opts.mysql.execute('SELECT * FROM force_users')
              .then(rs => rs[0][0])

            assert.equal(vader.name, 'Darth Vader')

            resolve()
          }
        })
      })
    })

    it('should write to the errors queue when an insert fails', async () => {
      stream.write({})

      return new Promise((resolve, reject) => {
        stream.end(async err => {
          if (err) reject(err)
          else {
            assert.equal(opts.bus.outQueueData.length, 1)
            resolve()
          }
        })
      })
    })
  })

  describe('#upsert', function () {
    it('should insert a new record when the record does not already exist in the db', async () => {
      const rs = await opts.mysql.upsert('force_users', forceUsers[2], 'id')

      const user = await opts.mysql.execute('SELECT * FROM force_users WHERE id = 3').then(rs => rs[0][0])

      assert.equal(rs.id, user.id)
      assert.equal(user.name, 'Yoda')
      assert.equal(user.death, null)
      assert(user.created_at !== null)
    })

    it('should update an existing record', async () => {
      await opts.mysql.upsert('force_users', forceUsers[0], 'id')
      await opts.mysql.upsert('force_users', { id: 1, status: 'Ghost' }, 'id')

      const rs = await opts.mysql.execute('SELECT * FROM force_users WHERE id = 1').then(rs => rs[0][0])

      assert.equal(rs.name, 'Darth Vader')
      assert.equal(rs.status, 'Ghost')
      assert(rs.created_at !== null)
    })

    it('should update an existing record when a different field is used as queryKey', async () => {
      await opts.mysql.upsert('force_users', forceUsers[0], 'name', 'id')
      await opts.mysql.upsert('force_users', Object.assign(forceUsers[0], { status: 'Updated' }), 'name', 'id')

      const rs = await opts.mysql.execute('SELECT * FROM force_users WHERE id = 1').then(rs => rs[0][0])

      assert.equal(rs.name, 'Darth Vader')
      assert.equal(rs.status, 'Updated')
      assert(rs.created_at !== null)
    })

    it('should return the id on an auto_increment column', async () => {
      const test = await opts.mysql.upsert('test', tests[0], 'id')
      assert.equal(test.id, 1)
    })

    it('should remove any undefined, null, or empty string fields from being inserted', async () => {
      await opts.mysql.upsert('force_users', {
        id: 5,
        name: 'Mace Windu',
        allegiance: null,
        rank: undefined,
        status: '',
        birth: '2018-01-01'
      }, 'id')

      const mace = await opts.mysql.execute('SELECT * FROM force_users WHERE `name` = "Mace Windu"').then(rs => rs[0][0])

      assert.equal(mace.name, 'Mace Windu')
      assert.equal(mace.allegiance, null)
      assert.equal(mace.rank, null)
      assert.equal(mace.status, null)
    })

    it('should set to null any field which is undefined, null, or empty string', async () => {
      await opts.mysql.upsert('force_users', Object.assign(forceUsers[1], { birth: '1970-01-02', death: '2017-01-02' }), 'id')

      const getLuke = async () => {
        return opts.mysql.execute('SELECT * FROM force_users WHERE id = 2').then(rs => rs[0][0])
      }

      let luke = await getLuke()

      assert.equal(luke.status, 'Unknown')
      assert.equal(luke.allegiance, 'Jedi')
      assert.equal(luke.rank, 'Master')
      assert.equal(moment(luke.death).format(), moment('2017-01-02').format())

      await opts.mysql.upsert('force_users', {
        id: 2,
        status: undefined,
        allegiance: null,
        death: ''
      }, 'id')

      luke = await getLuke()

      assert.equal(luke.id, 2)
      assert.equal(luke.rank, 'Master')
      assert.equal(luke.allegiance, null)
      assert.equal(luke.status, null)
      assert.equal(luke.death, null)
    })

    it('should not error when the row is empty', async () => {
      await opts.mysql.upsert('force_users', { id: null, name: undefined, allegiance: '' }, 'id')
    })

    it('should properly handle NULL queryKey values', async () => {
      /* Insert a record with a null queryKey value */
      await opts.mysql.execute('INSERT INTO force_users (id, name, birth) VALUES (1, \'Mace Windu\', \'2019-01-01\')')

      /* This second call should identify an existing record using the IS NULL operator.
      E.g., WHERE (name = 'Mace Windu) AND (status IS NULL)
      Vs,   WHERE (name = 'Mace Windu) AND (status = NULL) */
      await opts.mysql.upsert('force_users', {
        id: 1,
        name: 'Mace Windu',
        allegiance: 'Jedi',
        birth: '2019-01-01'
      }, ['name', 'status'])

      const rs = await opts.mysql.execute('SELECT * FROM force_users WHERE (name = \'Mace Windu\') AND (status IS NULL)')
      assert.equal(rs[0].length, 1)

      const mace = rs[0][0]
      assert.equal(mace.id, 1)
      assert.equal(mace.name, 'Mace Windu')
      assert.equal(mace.status, null)
      assert.equal(mace.allegiance, 'Jedi')
    })
  })

  describe('#getTableDefinition', async () => {
    let def
    before(async () => {
      def = await opts.mysql.getTableDefinition('force_users', 'id')
    })

    it('should return an object with name, columns and primary_key defined', async () => {
      assert('name' in def)
      assert('columns' in def)
      assert('primary_key' in def)
    })

    it('should return id as the primary_key value', async () => {
      assert.equal(def.primary_key, 'id')
    })

    it('should return with column definitions for allegiance and birth', async () => {
      const cols = def.columns.map(col => {
        return col.column_name
      })

      assert(cols.includes('allegiance'))
      assert(cols.includes('birth'))
    })

    it('should gracefully handle potential race conditions with two calls for the same table both resolving', async function () {
      await Promise.all([opts.mysql.getTableDefinition('users', 'id'), opts.mysql.getTableDefinition('users', 'id')])

      assert(true)
    })
  })
}
