fs         = require 'fs'
url        = require 'url'
http       = require 'http'

nodeStatic = require 'node-static'
staticS    = new nodeStatic.Server "./public"

hostNameUpdateFnc = ->
gets              = {}

module.exports.get = (key) ->
  if !gets[key]?
    gets[key] = @load "#{key}.json"
    return gets[key]
  return gets[key]

module.exports.set = (key, data) ->
  gets[key] = data

module.exports.load = (fileName) ->
  return JSON.parse fs.readFileSync fileName
  
module.exports.save = (fileName, json) ->
  fs.writeFileSync fileName, JSON.stringify json

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
  console.log exports.get 'wbList'
  socket.emit 'add-wbList', exports.get 'wbList'
  
  socket.on 'replace-wbListItem', (item) ->
    console.log 'replace-wbListItem'
    console.dir item
    
    wbList = exports.get 'wbList'
    
    for n,i in wbList
      if n.id is item.id
        wbList[i] = item
        break
    
    exports.set  'wbList',      wbList
    exports.save 'wbList.json', wbList
  
  socket.on 'new-wbListItem', (item) ->
    console.log 'new-wbListItem'
    console.dir item
    
    wbList = exports.get 'wbList'
    wbList.push item
    exports.set  'wbList',      wbList
    exports.save 'wbList.json', wbList
    
module.exports.toAll = (msg, data) ->
  ioServer.sockets.emit msg, data
  
module.exports.setHostnameUpdateFnc = ( fnc ) ->
  hostNameUpdateFnc = fnc