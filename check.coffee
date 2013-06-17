config = require './config'

hostnames = config.get 'hostnames'

forbidden = ['c.spiegel.de', 'prophet.heise.de']

badHrefs   = ['http://www.computerbase.de/stats.php', 'http://m.heise.de/avw-bin']

module.exports = (urlObj) ->

  if badHref urlObj.hostname, urlObj.href
    return false

  if badHostname urlObj.hostname
    return false

  return true

# false = hostname ist böse
# true  = hostname ist okay denn in liste

badHostname = (hostname) ->
  for n,i in forbidden
    if n is hostname
      console.log "\x1b[31mHOSTNAME -> #{hostname}\x1b[0m"
      return true

  for n,i in hostnames
    if -1 < hostname.search "[*.]#{n}$"
      console.log "\x1b[32mHOSTNAME -> #{hostname}\x1b[0m"
      return false
      
    if -1 < hostname.search "#{n}$"
      console.log "\x1b[32mHOSTNAME -> #{hostname}\x1b[0m"
      return false
  console.log "\x1b[31mHOSTNAME -> #{hostname}\x1b[0m"
  return true
  
badHref = (hostname, href) ->
  for n,i in badHrefs
    if -1 < href.search "^#{n}"
      console.log "\x1b[31mHREF -> #{href}\x1b[0m"
      return true

  console.log "\x1b[32mHREF -> #{href}\x1b[0m"
  return false