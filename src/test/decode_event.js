'use strict'

const base64Str = 'H4sIAAAAAAAAA+3SQW/bIBQA4Ht/BeXUSkkw2E4ca+qh3Q49dYdqp0kVIcRjtR8W4KpplP8+iNNIqRRplq/4YNnAew8e3w63fFtrvsblDss3Ce7Rf+IPwhJaEJoQlhFGSb4kNM+SjBbpPFkWdJocHoYnfVCIXuk+Fiqt10aJP9OnzSak/qVW8tlI+bPmQjZh9QRb3Rkhz1Z3Vhrrp9bSOgXcKQ1n83jvixmjTSgGvAnRPw7/E9xIa3kVRhplrYIKOQkcHBIaNqpCG22QqJWvjWpl/VwH6s2XU257HXbjuHj9TFei4Tl+A/IPd+jsnPZeu1kl3UOf4IbwtiW11NNVZ4k1gviW2fCa/bVlPi9pfntK9I2Dhm2jO3t3GmuNFv6gsxenxOt33XAFD7yuV37z6EaBkwZ4TY6rCMh3d1gZsjNWlItbvPc9VP99Scer7btuPwde+rvzqX3XHW9aXJ5s5EuaTPDlGRmKJ/ur3Sh2aWQX2X3BxS6yY0d2dCy7LLKL7AazY2PZ5ZFdZDeYXTqW3Tyyi+y+4EovskuP7LKx7BaRXWQ3mF0+ll0R2UV2g9nNx7JbRnaR3WB2i/3VP18fsMe4EwAA'

const gzipStr = Buffer.from(base64Str, 'base64')

const gunzip = require('zlib').gunzip

gunzip(gzipStr, (_, data) => {
  // console.log(data.toString())
})
