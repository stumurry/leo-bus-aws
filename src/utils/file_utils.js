
const fs = require('fs')

class FileUtils {
  walk (dir, done) {
    var results = []
    var _this = this
    fs.readdir(dir, function (err, list) {
      if (err) return done(err)
      var i = 0;
      (function next () {
        var file = list[i++]
        if (!file) return done(null, results)
        file = dir + '/' + file
        fs.stat(file, function (err, stat) {
          if (err) console.log(err)
          if (stat && stat.isDirectory()) {
            _this.walk(file, function (err, res) {
              if (err) console.log(err)
              results = results.concat(res)
              next()
            })
          } else {
            results.push(file)
            next()
          }
        })
      })()
    })
  }

  getFiles (dir) {
    return new Promise((resolve, reject) => {
      this.walk(dir, function (err, results) {
        if (err) {
          reject(err)
        } else {
          resolve(results)
        }
      })
    })
  }
}

module.exports = new FileUtils()
