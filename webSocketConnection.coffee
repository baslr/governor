
http       = require 'http'
wbList     = require './wbList'
nodeStatic = require 'node-static'
staticS    = new nodeStatic.Server "./public"

server = http.createServer()
server.listen 12101, '0.0.0.0'

ioServer = require('socket.io').listen(server)
ioServer.set('log level', 1)

server.on 'error', (e) ->
  console.error "http:server:e"
  console.dir    e

server.on 'request', (req, res) ->
  if  -1 is req.url.search '/socket.io/1'
    staticS.serve req, res
        
ioServer.sockets.on 'connection', (socket) ->
  socket.emit 'add-wbList', wbList.getItems()
  
  socket.on 'replace-wbListItem', (item) ->
    console.log 'replace-wbListItem'
    console.dir        item
    wbList.replaceItem item  
  
  socket.on 'new-wbListItem', (item) ->
    console.log 'new-wbListItem'
    console.dir    item    
    wbList.addItem item

module.exports.toAll = (msg, data) ->
  ioServer.sockets.emit msg, data
