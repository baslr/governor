config = require './config'

hostnames = config.get 'hostnames'  # god hostnames
cache     = {}

config.setHostnameUpdateFnc (hostName) ->
  for i,n of cache
    if -1 < i.search "#{hostName}$"
      delete cache[i]
      cache[hostName] = false
      return

forbidden = ['c.spiegel.de', 'prophet.heise.de']
badHrefs  = ['http://www.computerbase.de/stats.php', 'http://m.heise.de/avw-bin']

module.exports.isBad = (urlObj) ->

  if badHref urlObj.hostname, urlObj.href
    return true

  if badHostname urlObj.hostname
    return true

  return false

#  true = hostname ist böse
# false = hostname ist okay denn in liste

# 31 RED
# 32 GREEN

badHostname = (hostname) ->
  if cache[hostname]?
    console.log "hostnameCache: #{hostname}=#{cache[hostname]}"
    return cache[hostname]

  for n,i in forbidden
    if n is hostname
      console.log "\x1b[31mHOSTNAME -> #{hostname}\x1b[0m"   
      cache[hostname] = true
      return true

  for n,i in hostnames
    if -1 < hostname.search "[*.]#{n}$"
      console.log "\x1b[32mHOSTNAME -> #{hostname}\x1b[0m"
      cache[hostname] = false
      return false
      
    if -1 < hostname.search "#{n}$"
      console.log "\x1b[32mHOSTNAME -> #{hostname}\x1b[0m"
      cache[hostname] = false
      return false
      
  console.log "\x1b[31mHOSTNAME -> #{hostname}\x1b[0m"
  cache[hostname] = true
  return true
  
badHref = (hostname, href) ->
  for n,i in badHrefs
    if -1 < href.search "^#{n}"
      console.log "\x1b[31mHREF -> #{href}\x1b[0m"
      return true

  console.log "\x1b[32mHREF -> #{href}\x1b[0m"
  return false