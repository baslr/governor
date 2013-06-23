
crypto = require 'crypto'

cache = {}

module.exports = (val) ->

  if cache[val]?
    return cache[val]

  shasum = crypto.createHash 'md5'
  shasum.update val
  cache[val] = shasum.digest 'hex'

  return cache[val]