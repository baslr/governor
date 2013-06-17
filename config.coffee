
fs  = require 'fs'

gets = {}

module.exports.get = (key) ->
  if !gets['key']?
    gets['key'] = @load "#{key}.json"
    return gets['key']
  return gets['key']


module.exports.load = (fileName) ->
  return JSON.parse fs.readFileSync fileName
  
module.exports.save = (fileName, json) ->
  fs.writeFileSync fileName, JSON.stringify json
  
module.exports.request = (req, res, urlObj) ->

  if urlObj.query?
    newHostName = urlObj.query.split('=')[1]
    
    json = @get 'hostnames'
    
    if -1 is json.indexOf newHostName
      json.push newHostName
      @save 'hostnames.json', json

  fs.createReadStream('index.html').pipe res