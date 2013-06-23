@app  = c:{}, socket:undefined

app.setUp = ->
  @socket = io.connect "#{document.location.protocol}//#{document.location.hostname}:#{document.location.port}"  
  
# ['formats Formats SELECT'] # only 1 space is imminent
# formatsVM FormatsViewModel SELECT
app.boil = (cfg) ->

  for a in cfg
    n = a.split ' '
    console.log "boil #{n[0]} #{n[1]} #{n[2]}"
    app["#{n[0]}VM"] = new app.c["#{n[1]}ViewModel"]()
    ko.applyBindings app["#{n[0]}VM"], ($ n[2]).get 0

($ document).ready ->
  app.setUp()
  app.initSocketMessages()