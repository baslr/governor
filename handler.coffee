id          = Math.floor new Date().getTime()/1000
ipAddresses = []
extensions  = require './extensions.json'

os     = require 'os'
url    = require 'url'
http   = require 'http'

check  = require './check'
cache  = require './cache'
config = require './config'
lf      = require './lovefilm'

for i,n of os.networkInterfaces()
  for m,j in n
    if m.family is 'IPv4' and m.internal is false and m.address isnt '127.0.0.1'
      ipAddresses.push m.address
console.log ipAddresses

module.exports = (req, res) ->
  container = {id:id++, time:Math.floor new Date().getTime()/1000}

  delete req.headers['cookie']                                                                      # remove non needed kram
  delete req.headers['proxy-connection']

  req.on 'error', (e) ->
    console.error 'http:server:request:req:e'
    console.dir    e
    
  res.on 'error', (e) ->
    console.error 'http:server:request:res:e'
    console.dir    e

  req.on 'readable', ->
    @read()

  urlObj = url.parse req.url

  container.method   =    req.method 
  container.hostname = urlObj.hostname
  container.path     = urlObj.path
  
  container.contentid = 0
  container.qL        = 0
  container.type      = 0
  container.fragment  = 0
  container.quality   = 0
  container.language  = 0
  container.cached    = '0'

  if 'post' is req.method.toLowerCase()
    config.toAll 'add-container', container
    res.end()
    return
    
  if check.isBad urlObj
    config.toAll 'add-container', container
    res.statusCode = 500
    res.end ''
    return

  req.on 'end', ->
    if -1 < urlObj.path.search '/lf/encrypted/'
      lf.pathInfo urlObj.path, container

      if lf.isCached urlObj.path
        res.end lf.getCachedData urlObj.path
        container.cached = '1'
        config.toAll 'add-container', container
        return

    if cache.deliver urlObj, res
      container.cached = '1'
      config.toAll 'add-container', container
      return

    reqReq = http.request {  localAddress: ipAddresses[0] # 192.168.2.100' #'192.168.42.11' #
                  , hostname: urlObj.hostname
                  , path:     urlObj.path
                  , headers: req.headers}, (reqRes) ->
      
      res.statusCode = reqRes.statusCode
      res.setHeader i,n for i,n of reqRes.headers

      if urlObj.hostname is 'mobil.zeit.de' and reqRes.headers['content-encoding']? and reqRes.headers['content-encoding'] is 'gzip'      
        data = new Buffer 0
        
        reqRes.on 'readable', ->
          data = Buffer.concat [data, @read()]
      else if -1 < urlObj.path.search '^/lf/encrypted/'
        data = new Buffer 0
        
        reqRes.on 'readable', ->
          data = Buffer.concat [data, @read()]
      else if -1 < urlObj.path.search "\\.(#{extensions.join '|'})$"
        data = new Buffer 0
        reqRes.on 'readable', ->
          data = Buffer.concat [data, @read()]
      else
        reqRes.pipe res
        
#       reqRes.on 'readable', ->
#         console.log "readable for #{urlObj.href}"
      
      reqRes.on 'end', ->
        if -1 < urlObj.path.search '^/lf/encrypted/'
          lf.cacheData urlObj.path, data
          res.end data
          
        if -1 < urlObj.path.search "\\.(#{extensions.join '|'})$"
          cache.cache urlObj.href, data, reqRes.headers['content-encoding']
          console.log "Done Caching #{urlObj.href}"
          res.end data
        
        if urlObj.hostname is 'mobil.zeit.de' and reqRes.headers['content-encoding']? and reqRes.headers['content-encoding'] is 'gzip'
          zlib.unzip data, (e, result) ->      
            data = result.toString().replace "return (document.cookie.indexOf('facdone')!=-1)? true : false;", 'return false;'
            zlib.gzip data, (e, result) ->
              res.end result
        
        config.toAll 'add-container', container

    reqReq.end()
    
    reqReq.on 'error', (e) ->
      console.error 'http.request:e'
      console.dir    e
      console.log   "error: #{urlObj.href}"
      res.statusCode = 500
      res.end()
      
      if -1 < urlObj.path.search '\\.js$'
        console.log "Delete Cache #{urlObj.href}"
        cache.delete href