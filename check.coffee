

wbList    = require './wbList'

#  true = hostname bad
# false = hostname god

module.exports.isBad = (urlObj) ->

  dbg 'check in bad hostnames'
  if wbList.inBadHostnames urlObj.hostname
    dbg "IN BAD HOSTNAMES: #{urlObj.hostname}"
    return true

  dbg 'check for bad href'
  if wbList.isBadHref urlObj.href
    return true
  
  dbg 'check for bad hostname'
  if wbList.isBadHostname urlObj.hostname
    console.log "BAD: #{urlObj.hostname}"
    wbList.addItem { s: urlObj.hostname, type: 'domain', list: 'black', id: new Date().getTime() }
    
    return true
  
  return false
