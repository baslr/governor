fs      = require 'fs'
zlib    = require 'zlib'
http    = require 'http'
https   = require 'https'

handler = require './handler'

httpServer = http.createServer()
httpServer.listen 12100, '0.0.0.0'

httpServer.on 'error', (e) ->
  console.error "http:server:e"
  console.dir    e

httpServer.on 'request', (req, res) ->
  handler req, res




options = {key: fs.readFileSync('key.pem'), cert: fs.readFileSync('cert.pem') }

httpsServer = https.createServer options
httpsServer.listen 12200, '0.0.0.0'

httpsServer.on 'error', (e) ->
  console.error "https:server:e"
  console.dir    e

httpsServer.on 'request', (req, res) ->
  console.log "request in"

  req.on 'readable', ->
    @read()


  req.on 'end', ->
    console.log "req: #{req.url}"
    res.end ':D'

  req.on 'error', (e) ->
    console.log "req:e"
    console.dir  e
    
httpsServer.on 'secureConnection', ->
  console.log "secureConnection"
  
  
httpsServer.on 'clientError', (exception, securePair) ->
  console.log "client error"
  console.dir  exception
  console.dir  securePair
  
  
  
  
  
httpsServer.on 'newSession', ->
  console.log "newSession"
  
httpsServer.on 'resumeSession', ->
  console.log "resumeSession"