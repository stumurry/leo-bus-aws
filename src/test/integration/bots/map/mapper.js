'use strict'

module.exports = (opts) => {
  const Mapper = require('../../../../bots/map/mapper')
  const assert = opts.assert
  let mapper

  before(() => {
    mapper = new Mapper(opts.mysql)
  })

  describe('#lookupId', () => {
    const dropTable = 'DROP TABLE IF EXISTS test_lookup'
    before(async () => {
      await opts.mysql.execute(dropTable)
      await opts.mysql.execute(
        `CREATE TABLE test_lookup (
          id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
          description varchar(255) DEFAULT NULL
        ) ENGINE=InnoDB`
      )
    })

    after(async () => {
      await opts.mysql.execute(dropTable)
    })

    it('should return a null primaryKey value when the lookupField value is 0', async () => {
      try {
        const rs = await mapper.lookupId({
          client_id: 0,
          field: 'test'
        }, {
          lookupField: 'client_id',
          primaryKeyField: 'id',
          tbl: 'testTbl'
        })

        assert.equal(rs, null)
      } catch (err) {
        console.log(err)
      }
    })

    it('should create a new lookup record and return the lookup if it does not exist', async () => {
      const id = await mapper.lookupId({
        id: 2,
        description: 'Lookup Value'
      }, {
        lookupField: 'id',
        primaryKeyField: 'id',
        tbl: 'test_lookup'
      })

      const rs = await opts.mysql.execute('SELECT * FROM test_lookup WHERE id = 2')
      const data = rs[0][0]
      assert.strictEqual(data.description, 'Lookup Value')
      assert.strictEqual(data.id, 2)
      assert.strictEqual(id, 2)
    })

    it('should find an existing lookup record and return the id', async () => {
      const data = {
        id: 3,
        description: 'Another Test Value'
      }
      const insert = opts.mysql.squel.insert()
        .into('test_lookup')
        .setFields(data)
        .toParam()

      await opts.mysql.execute(insert.text, insert.values)
      const id = await mapper.lookupId(data, {
        lookupField: 'id',
        primaryKeyField: 'id',
        tbl: 'test_lookup'
      })

      assert.strictEqual(id, data.id)
    })

    it('should fetch the recently inserted id when insertId is not returned', async () => {
      try {
        await opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')
        const id = await mapper.lookupId({
          id: 4,
          description: 'Test'
        }, {
          primaryKeyField: 'id',
          lookupField: 'id',
          tbl: 'tree_order_statuses'
        })

        assert.strictEqual(id, 4)
      } catch (err) {
        assert.fail(err)
      }
    })

    it('should resolve multiple calls in a Promise.all and exit successfully', () => {
      return Promise.all([
        mapper.lookupId({
          id: 2,
          description: 'Lookup Value'
        }, {
          lookupField: 'id',
          primaryKeyField: 'id',
          tbl: 'test_lookup'
        }),
        mapper.lookupId({
          id: 1,
          description: 'test_lookup'
        }, {
          lookupField: 'id',
          primaryKeyField: 'id',
          tbl: 'test_lookup'
        })
      ]).then(rs => {
        assert(true)
      })
    })
  })

  describe('#treeUserId', () => {
    before(async () => {
      await opts.mysql.execute('TRUNCATE TABLE tree_order_statuses')
      await opts.mysql.execute('TRUNCATE TABLE tree_users')
    })

    it('should return a treeUserId of 1', async () => {
      const id = await mapper.treeUserId(2)

      assert.strictEqual(id, 1)
    })

    it('should find an existing tree_user where client_user_id = 2', async () => {
      const id = await mapper.treeUserId(2)

      assert.strictEqual(id, 1)
    })

    it('should find the same tree_user_id if called multiple times in sync', async () => {
      const [id1, id2, id3] = await Promise.all([
        mapper.treeUserId('client_1'),
        mapper.treeUserId('client_1'),
        mapper.treeUserId('client_1')
      ]).catch(err => {
        console.log(err)

        assert.fail(err)
      })

      assert.equal(id1, id2)
      assert.equal(id1, id3)
    })
  })
}
