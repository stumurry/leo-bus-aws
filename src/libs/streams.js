class Streams {
  checkEmptyPayload (ls) {
    return ls.through((obj, done) => {
      if (Object.keys(obj.payload).length === 0) {
        done(null)
      } else {
        done(null, obj)
      }
    })
  }

  /***
    * @author: s murry.
    * @summary: BigQuery requires new lines after every line in order to load correctly.
    * @date 9/3/2019
    */
  stringifyJsonNewlineDelimited (ls) {
    return ls.through(async (obj, done) => {
      const str = `${JSON.stringify(obj.payload)}\n`
      done(null, str)
    })
  }

  log (ls) {
    return ls.through((obj, done) => {
      console.log('streams.log()', obj)
      done(null, obj)
    })
  }
}

module.exports = new Streams()
