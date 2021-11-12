
class LeoUtils {
  async offloadDestinationQueue (leo, queue) {
    var payloads = []
    await new Promise((resolve, reject) => {
      const botId = `${process.env.EXTUSER}-DestinationQueueTester`
      leo.offload({
        id: botId,
        queue: queue,
        each: (payload, meta, done) => {
          payloads.push(payload)
          done(null, true)
        }
      }, (err) => {
        if (!err) { resolve() } else reject(err)
      })
    })
    return payloads
  }
}

module.exports = new LeoUtils()
