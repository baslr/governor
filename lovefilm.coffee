fs  = require 'fs'

lfCache = {}

for dir in fs.readdirSync 'lfCache'
  if fs.statSync("lfCache/#{dir}").isDirectory()
    try
      lfCache[dir] = JSON.parse fs.readFileSync "lfCache/#{dir}/cached.json"
    catch e
      console.log "fs:readFileSync"
      console.dir  e

for i,n of lfCache
  console.log i

module.exports.isCached = (path) ->
  info = @fragmentInfo path
  
  if lfCache["#{info.contentid}-#{info.language}-#{info.quality}"]?[info.type]?[info.fragment]?
    console.log "isCached=true #{@fragmentInfo path, false}"
    return true
  return false
  
  return fs.existsSync "lfCache/#{info.contentid}-#{info.language}-#{info.quality}/#{@fragmentInfo path, false}"
  
module.exports.getCachedData = (path) ->
  info = @fragmentInfo path
  file = lfCache["#{info.contentid}-#{info.language}-#{info.quality}"][info.type][info.fragment].file
  return fs.readFileSync "lfCache/#{info.contentid}-#{info.language}-#{info.quality}/#{file}"

module.exports.cacheData = (path, data) ->
  info = @fragmentInfo path
  
  if !fs.existsSync "lfCache/#{info.contentid}-#{info.language}-#{info.quality}"
    fs.mkdirSync    "lfCache/#{info.contentid}-#{info.language}-#{info.quality}"
  fs.writeFileSync  "lfCache/#{info.contentid}-#{info.language}-#{info.quality}/#{@fragmentInfo path, false}", data
  
module.exports.pathInfo = (path, container) ->
  info = @fragmentInfo path
  container.qL        = info.qL
  container.type      = info.type
  container.fragment  = info.fragment
  container.quality   = info.quality
  container.contentid = info.contentid
  container.language  = info.language

module.exports.fragmentInfo = (path, obj = true) ->
  info = {}
  
  info.qL = path.split('QualityLevels(')[1].split(')')[0]

  nxt  = path.split('/Fragments(')[1].split(')')[0].split('=')
  
  if nxt[0] is 'video'
    info.type = 'video'
  else
    info.type = 'audio'

  info.typeTag  = nxt[0]
  info.fragment = nxt[1]  

  if -1 < path.search '/PRSDe/'
    info.quality = 'SD'
  else
    info.quality = 'HD'
    
  info.contentid = path.split(/_PR(SD|HD).ism/)[0].split('_').pop()
  info.language  = path.split("_#{info.contentid}")[1].split('/').pop()
  
  if obj
    return info
  else
    return "#{info.contentid}-#{info.language}-#{info.quality}-#{info.fragment}-#{info.type}-#{info.qL}"
    
module.exports.fragmentPathFromObj = (obj) ->
  return "/lf/encrypted/PRSDe/#{obj.language}/#{obj.language}_#{obj.contentid}_PRSDe/#{obj.language}_#{obj.contentid}_PR#{obj.quality}.ism/QualityLevels(#{obj.qL})/Fragments(#{obj.typeTag}=#{obj.fragment})"

