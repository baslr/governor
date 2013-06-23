
fs   = require 'fs'
zlib = require 'zlib'
md5  = require './md5'

writeCacheFile = (href, data) ->
  fs.writeFileSync "cache/#{md5 href}", data

readCacheFile = (href) ->
  return fs.readFileSync "cache/#{md5 href}"

module.exports.isCache = (href) ->
   return fs.existsSync "cache/#{md5 href}"

module.exports.cache = (href, data, encoding) ->

  switch encoding
    when 'gzip'
      writeCacheFile href, data
      
    when 'deflate'
      zlib.inflate data, (e, result) ->
        zlib.gzip result, (e, result) ->
          writeCacheFile href, result
    
    when undefined
      zlib.gzip data, (e, result) ->
        writeCacheFile href, result
        
module.exports.getCache = (href) ->
  return readCacheFile href
    
module.exports.delete = (href) ->
  fs.unlink 