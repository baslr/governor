
cookies   = {'www.heise.de':0}

os     = require 'os'
zlib   = require 'zlib'

http   = require 'http'
url    = require 'url'

check  = require './check'
config = require './config'





ipAddresses = []

for i,n of os.networkInterfaces()
  for m,j in n
    if m.family is 'IPv4' and m.internal is false and m.address isnt '127.0.0.1'
      ipAddresses.push m.address



console.log ipAddresses




server = http.createServer()

server.listen 12100, '0.0.0.0'

server.on 'error', (e) ->
  console.error "http:server:e"
  console.dir    e
  
  
server.on 'request', (req, res) ->

  req.on 'error', (e) ->
    console.error 'http:server:request:req:e'
    console.dir    e
    
  res.on 'error', (e) ->
    console.error 'http:server:request:res:e'
    console.dir    e

  urlObj = url.parse req.url
  
  if urlObj.hostname is 'config'
    config.request req, res, urlObj
    return
  

  delete req.headers['cookie']
  delete req.headers['proxy-connection']


#  if cookies[urlObj.hostname]? and cookies[urlObj.hostname] is 0

#    console.log "delete cookies"

  console.dir req.headers
#  console.dir req.method
  console.dir req.url
  
  if 'post' is req.method.toLowerCase()
    console.log "\x1b[31mPOST: #{urlObj.hostname} #{urlObj.path}\x1b[0m"
    res.end()
    return
    
  if !check urlObj
    console.log "\x1b[31mBLOCKED -> #{urlObj.href}\x1b[0m"
    res.statusCode = 500
    res.end()
    return
  
  console.dir '- - - - - - - - - - - - - - - - - - - - - - - - - - -'
  
  req.on 'readable', ->
    @read()
  
  req.on 'end', ->
    reqReq = http.request {  localAddress: ipAddresses[0] # 192.168.2.100' #'192.168.42.11' #
                  , hostname: urlObj.hostname
                  , path:     urlObj.path
                  , headers: req.headers}, (reqRes) ->
      console.log "req for: #{req.url}"
      
      res.statusCode = reqRes.statusCode
      
      console.dir reqRes.headers
      
      for i,n of reqRes.headers
        res.setHeader i,n

      if urlObj.hostname is 'mobil.zeit.de' and reqRes.headers['content-encoding']? and reqRes.headers['content-encoding'] is 'gzip'      
        data = new Buffer 0
      
        reqRes.on 'readable', ->
          data = Buffer.concat [data, @read()]
      else
        reqRes.pipe res
      
      reqRes.on 'end', ->
        console.log "RESPONSE FULL DONE FOR #{urlObj.hostname} #{urlObj.path}"
        
        if urlObj.hostname is 'mobil.zeit.de' and reqRes.headers['content-encoding']? and reqRes.headers['content-encoding'] is 'gzip'
          zlib.unzip data, (e, result) ->      
            data = result.toString().replace "return (document.cookie.indexOf('facdone')!=-1)? true : false;", 'return false;'
            zlib.gzip data, (e, result) ->
              res.end result
        
            


        
    reqReq.end()
    
    reqReq.on 'error', (e) ->
      console.error 'http.request:e'
      console.dir    e