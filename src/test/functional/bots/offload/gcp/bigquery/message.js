'use strict'
const { BigQuery } = require('@google-cloud/bigquery')
const utils = require('../../../../../../libs/utils')

module.exports = (opts) => {
  const assert = opts.assert

  let bigquery
  let settings

  before((done) => {
    opts = opts.setOptsForBot('offload/gcp/bigquery', opts)

    let botSettings = {
      bot_id: 'OffloadGCPBigQuery-var-Message',
      queue: 'vibe-messages',
      data_set: 'lake',
      table_name: 'pyr_messages'
    }

    settings = { ...botSettings, botId: 'OffloadGCPBigQuery' }

    const events =
      [
        {
          id: 3,
          sender_id: 3,
          sender_type: 'Test::User',
          sent_date: '2019-09-02T14:56:35.000Z',
          to: 'testy.tester+2@gmail.com',
          from: 'tester.testy+2@icentris.com',
          subject: 'Subject4',
          message: 'message4',
          short_message: null,
          draft: 1,
          delivery_status: 'unsent',
          reply_to_id: null,
          forwarded_from_id: null,
          internal_recipient_count: null,
          internal_open_count: null,
          size: null,
          has_attachments: 0,
          message_extras: null,
          message_created_at: null,
          message_updated_at: null,
          message_type: 0,
          system_generated: 0,
          message_tag_deleted: 0,
          message_tag_trash: 0,
          message_tag_important: 0,
          message_tag_starred: 0,
          message_cc: null,
          message_bcc: null,
          undeliverable_count: null,
          spam_reported_count: null,
          tag_spam: 0,
          icentris_client: 'bluesun'
        },
        {
          id: 1,
          sender_id: 1,
          sender_type: null,
          sent_date: '2019-04-30T09:20:08.000Z',
          to: 'icentris+Rosalinda.Parisian42@gmail.com',
          from: 'icentris+Deontae40@gmail.com',
          subject: 'Non reiciendis ea eaque illo eum libero perferendis ut et.',
          message: 'Excepturi id iste in explicabo alias recusandae. Rerum rerum quaerat unde soluta iste sequi voluptate consequatur quaerat. Accusamus quaerat ut voluptatem nihil nostrum sequi. Adipisci animi nobis excepturi quas ad consequuntur laudantium sed.\n \rIpsa dolores est quis est nihil quis beatae iusto. Ut illo accusamus facere. Deserunt magnam ad ipsum mollitia facere inventore iste consequuntur nesciunt. Harum quae nesciunt provident asperiores laborum.\n \rItaque velit earum sed. Modi fugiat et aut nihil ea reprehenderit occaecati delectus commodi. Non sit quis explicabo ut occaecati enim illum nobis vero. Quo animi qui optio praesentium et rerum eligendi. Id quisquam iure nobis aliquam delectus doloremque velit adipisci porro. Unde est similique aut.',
          short_message: 'Excepturi id iste in explicabo alias recusandae. R',
          draft: 0,
          delivery_status: 'sent',
          reply_to_id: 1,
          forwarded_from_id: null,
          internal_recipient_count: 1,
          internal_open_count: 1,
          size: 754,
          has_attachments: 0,
          message_extras: null,
          message_created_at: '2019-08-20T00:00:00.000Z',
          message_updated_at: '2018-09-06T22:20:29.000Z',
          message_type: 1,
          system_generated: 0,
          message_tag_deleted: 0,
          message_tag_trash: 0,
          message_tag_important: 0,
          message_tag_starred: 0,
          message_cc: null,
          message_bcc: null,
          undeliverable_count: 0,
          spam_reported_count: 0,
          tag_spam: 0,
          icentris_client: 'bluesun'
        }
      ]

    done()
    return opts.bootstrapSource(opts, events)
  })

  /**
   * @author S. Murry
   * @date 9/23/19
   *
   * Skipping this test, because we can't get a reliable test.
   * The test is good, however, Google doesn't guarantee data
   * time availabilty when doing batch upload.
   */
  describe('#handle', () => {
    it.skip('should write to bigquery', async () => {
      await opts.setCheckpointsToCurrent(opts)
      const config = await opts.bot.getRemoteConfig('bluesun').then(c => {
        return c
      })

      bigquery = new BigQuery(config.gcp)

      const dataSetName = settings.data_set
      // const dataSetNameWithEnv = `${dataSetName}_${process.env.NODE_ENV}`

      const dataset = bigquery.dataset(dataSetName)
      // const [exists] = await dataset.exists()
      // if (exists) {
      //   console.log('dataset exists.  Deleting')
      //   await dataset.delete({ force: true })
      // }

      opts.event.data_set = settings.data_set
      opts.event.icentris_client = 'bluesun'
      opts.event.botId = settings.bot_id
      opts.event.table_name = settings.table_name
      opts.event.queue = settings.queue

      await opts.bot.handle(opts.event, opts.context)

      const results = await dataset.query('select * from pyr_messages')

      /**
       * @author S.Murry
       * @date 9/18/19
       * Need to wait for GCP to make data available.  Since we are uploading in batch, which is free,
       * Google doesn't guarantee data readiness.  When using the streaming api, data is guaranteed, however,
       * you have to pay for that convenience.
       *
       */
      console.log('Waiting for Google to update their dataset')
      await utils.timeout(5000)

      assert.equal(results[0].length, 2, 'Bigquery dataset message should contain 2 record')
    }).timeout(180000)
  })
}
