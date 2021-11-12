'use strict'

module.exports = (opts) => {
  const utils = require('../../../libs/utils')
  const assert = opts.assert

  describe(('#snakeToCamel'), function () {
    it('is true', function () {
      assert(true)
    })

    it('converts "user" to "user"', function () {
      const snake = 'user'
      const camel = 'user'

      const result = utils.snakeToCamel(snake)

      assert.strictEqual(result, camel)
    })

    it('converts "user_id" to "userId"', function () {
      const snake = 'user_id'
      const camel = 'userId'

      const result = utils.snakeToCamel(snake)

      assert.strictEqual(result, camel)
    })

    it('converts "user_id_special" to "userIdSpecial"', function () {
      const snake = 'user_id_special'
      const camel = 'userIdSpecial'

      const result = utils.snakeToCamel(snake)

      assert.strictEqual(result, camel)
    })
  })
}
