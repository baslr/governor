
zlib   = require 'zlib'
http   = require 'http'

handler = require './handler'

server = http.createServer()
server.listen 12100, '0.0.0.0'

server.on 'error', (e) ->
  console.error "http:server:e"
  console.dir    e

server.on 'request', (req, res) ->
  handler req, res