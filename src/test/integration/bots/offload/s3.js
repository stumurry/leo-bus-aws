'use strict'

const crypto = require('crypto')
const faker = require('faker')
const fs = require('fs')
const readline = require('readline')
const path = require('path')
const zlib = require('zlib')

const encryptionKey = require('../../../config').bus.secrets.gcp

const decrypt = (text) => {
  const textParts = text.split(':')
  const iv = Buffer.from(textParts.shift(), 'hex')
  const encrypted = Buffer.from(textParts.join(':'), 'hex')
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(encryptionKey, 'base64'), iv)
  const decrypted = decipher.update(encrypted)

  return Buffer.concat([decrypted, decipher.final()])
}

module.exports = (opts) => {
  const assert = opts.assert

  let bot
  before(() => {
    bot = opts.getBot('offload/s3')
    opts.event.queue = 'users'
  })

  describe('#handle', () => {
    afterEach(() => {
      const dir = `${process.cwd()}/test/mocks/icentris-gcp-${process.env.NODE_ENV}`
      const files = fs.readdirSync(dir)
      for (const file of files) {
        if (file !== '.gitignore') {
          fs.unlinkSync(path.join(dir, file))
        }
      }
    })

    it('should not create a final file with empty payloads', async () => {
      opts.bus.inQueueData = []

      await bot.handle(opts.event, opts.context)

      const file = `${process.cwd()}/test/mocks/${bot.bucket}/${opts.event.queue}-final-${bot.checksum}-${bot.timestamp}`

      assert(!fs.existsSync(file))
    })

    it('should not create an event with empty payloads', async () => {
      opts.bus.inQueueData = []

      await bot.handle(opts.event, opts.context)

      assert.deepEqual(opts.bus.outQueueData, [])
    })

    it('should create a final file with iv and encrypted string for each record which can then be decrypted back to json', async () => {
      opts.bus.inQueueData = []

      const rand = Math.random() * (100 - 5) + 5

      for (let i = 0; i < rand; i++) {
        const obj = {
          id: faker.random.number(),
          name: faker.name.findName(),
          email: faker.internet.email(),
          title: faker.name.jobTitle(),
          description: faker.lorem.sentences()
        }

        opts.bus.inQueueData.push(obj)
      }

      await bot.handle(opts.event, opts.context)

      const file = `${process.cwd()}/test/mocks/${bot.bucket}/${opts.event.queue}-final-${bot.checksum}-${bot.timestamp}`

      assert(fs.existsSync(file))

      opts.bus.outQueueData = []
      const rl = readline.createInterface({
        input: fs.createReadStream(file)
      })

      return new Promise((resolve, reject) => {
        rl.on('line', (line) => {
          const decrypted = decrypt(line.trim())
          const gunzip = zlib.gunzipSync(decrypted)
          const json = JSON.parse(gunzip)
          opts.bus.outQueueData.push(json)
        })

        rl.on('close', (err) => {
          if (err) reject(err)
          else {
            assert.deepEqual(opts.bus.outQueueData, opts.bus.inQueueData)
            resolve()
          }
        })
      })
    })

    it('should create n number of payloads', async () => {
      const n = 100
      opts.bus.inQueueData = []
      opts.event.maxRecords = 50

      for (let i = 0; i < n; i++) {
        const obj = {
          id: faker.random.number(),
          name: faker.name.findName(),
          email: faker.internet.email(),
          title: faker.name.jobTitle(),
          description: faker.lorem.sentences()
        }
        opts.bus.inQueueData.push(obj)
      }

      await bot.handle(opts.event, opts.context)

      const file = `${process.cwd()}/test/mocks/${bot.bucket}/${opts.event.queue}-final-${bot.checksum}-${bot.timestamp}`

      assert(fs.existsSync(file))

      opts.bus.outQueueData = []
      const rl = readline.createInterface({
        input: fs.createReadStream(file)
      })

      return new Promise((resolve, reject) => {
        rl.on('line', (line) => {
          const decrypted = decrypt(line.trim())
          const gunzip = zlib.gunzipSync(decrypted)
          const json = JSON.parse(gunzip)
          opts.bus.outQueueData.push(json)
        })

        rl.on('close', (err) => {
          if (err) reject(err)
          else {
            console.log('opts.bus.outQueueData.length', opts.bus.outQueueData.length)
            assert.equal(opts.bus.outQueueData.length, opts.event.maxRecords)
            resolve()
          }
        })
      })
    })

    it('should write to a queue the bucket and key of the aws resource', async () => {
      opts.bus.inQueueData = []

      const rand = Math.random() * (100 - 5) + 5

      for (let i = 0; i < rand; i++) {
        const obj = {
          id: faker.random.number(),
          name: faker.name.findName(),
          email: faker.internet.email(),
          title: faker.name.jobTitle(),
          description: faker.lorem.sentences()
        }
        opts.bus.inQueueData.push(obj)
      }

      await bot.handle(opts.event, opts.context)

      const file = `${opts.event.queue}-final-${bot.checksum}-${bot.timestamp}`

      const payloads = opts.bus.outQueueData.map(s => { return s.payload })
      assert.deepEqual(payloads, [{ Key: file, Bucket: bot.bucket }])
    })
  })
}
