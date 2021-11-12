'use strict'

const aws = require('aws-sdk')
const fs = require('fs')
const s3 = new aws.S3()

s3.rename = async (bucket, oldKey, newKey) => {
  const metaData = await s3.headObject({ Bucket: bucket, Key: oldKey }).promise()

  if (metaData.ContentLength > 0) {
    await s3.copyObject({
      Bucket: bucket,
      CopySource: `/${bucket}/${oldKey}`,
      Key: newKey
    }).promise()

    await s3.deleteObject({
      Bucket: bucket,
      Key: oldKey
    }).promise()
    return true
  } else {
    return false
  }
}

s3.uploadFile = async (bucket, key, fileName) => {
  const readStream = fs.createReadStream(fileName)
  const params = {
    Bucket: bucket,
    Key: key,
    Body: readStream
  }
  await s3.upload(params, function (err, data) {
    if (err) {
      throw err
    }
    console.log(`File uploaded successfully. ${data.Location}`)
  }).promise()

  return true
}

module.exports = s3
