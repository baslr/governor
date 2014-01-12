fs            = require 'fs'
hrefCache     = {}
hostnameCache = {}

try
  wbList = require './wbList.json'
catch
  wbList = []

save = () -> fs.writeFileSync 'wbList.json', JSON.stringify wbList

# 31 RED
# 32 GREEN

# type url
# type domain

module.exports.isBadHref = (href) ->
  console.dir Object.keys(hrefCache).length
  
  if hrefCache[href]?
    dbg "FROM CACHE: #{href} |#{hrefCache[href]}"
    return hrefCache[href]
  
  for n,i in wbList
    if n.type is 'url' and n.list is 'black' and -1 < href.search("^#{n.s}")
      console.log "\x1b[31mHREF -> #{href}\x1b[0m 1"
      hrefCache[href] = true
      return true
    
  console.log "\x1b[32mHREF -> #{href}\x1b[0m 2"
  hrefCache[href] = false
  return false

module.exports.inBadHostnames = (hostname) ->
  for n,i in wbList
    if n.type is 'domain' and n.list is 'black'
      return true if n.s is hostname
      return true if -1 < hostname.search "[*\.]#{n.s}$"
  
  return false


module.exports.isBadHostname = (hostname) ->
#  return cache[hostname] if hostnameCache[hostname]?
  
  # check for identical hostname in the list
  for n,i in wbList
    if n.type is 'domain' and n.s is hostname
      if n.list is 'black'
        console.log "\x1b[31mHOSTNAME -> #{hostname} 1 \x1b[0m"
        return true
      else if n.list is 'white'
        console.log "\x1b[32mHOSTNAME -> #{hostname} 1 \x1b[0m"   
        return false
  
  
  
  # allow subdomains by default for whitelist
  for n,i in wbList
    if      n.type is 'domain' and n.list is 'white' and -1 < hostname.search("[*\.]#{n.s}$")
      console.log "\x1b[32mHOSTNAME -> #{hostname} 2 \x1b[0m"
      return false
    
#   for n,i in wbList
#     if -1 < n.type is 'domain' and n.list is 'white' and hostname.search "#{n.s}$"
#       console.log "\x1b[32mHOSTNAME -> #{hostname} 3 \x1b[0m"
#       return false

  
  console.log "\x1b[31mHOSTNAME -> #{hostname} 4 \x1b[0m"
  return true


module.exports.replaceItem = (item) ->
  for n,i in wbList
    if n.id is item.id
      wbList[i] = item
      hrefCache     = {}
      hostnameCache = {}
      save()
      break

module.exports.addItem = (item) ->
  for n in wbList
    return if n.type is 'domain' and item.type is 'domain' and n.s is item.s
    return if n.type is 'href'   and item.type is 'href'   and n.s is item.s
  
  wbList.push item
  hrefCache     = {}
  hostnameCache = {}
  save()

module.exports.getItems = () -> wbList
