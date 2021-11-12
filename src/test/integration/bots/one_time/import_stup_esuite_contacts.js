'use strict'

module.exports = (opts) => {
  const assert = opts.assert
  let bot
  beforeEach(() => {
    bot = opts.getBot('one_time/import_stup_esuite_contacts')
  })

  describe('#import one time esuite file payload to Vibe', async function () {
    it('should import contacts', async () => {
      const expectedOut = ['4000547|#|Sally|#|Stamper|#|09 817 1361|#||#|stamper@stamper.com|#|41 Huia Rd|#||#|Auckland|#|Titirangi|#||#|4555|#|NZ|#|N|#|N|#|N|#|1|#|N|#|N|#||#|1989|#|12|#|8|#|2009|#|11|#|1|#|customerManager|#|16248']
      opts.event = {
        icentris_client: 'bluesun',
        file: 'Content.csv',
        ...opts.event
      }
      await bot.handle(opts.event, opts.context)
      const out0 = opts.bus.outQueueData[0].payload
      assert.deepEqual(out0, expectedOut)
    })
  })
}
