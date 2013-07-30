
app.initSocketMessages = ->
  @socket.on 'add-container', (container) ->
    app.containerVM.add container
  
  @socket.on 'add-wbList', (wbList) ->
    app.wbListVM.add n for n,i in wbList
