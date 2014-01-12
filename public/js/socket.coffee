
app.initSocketMessages = ->
  @socket.on 'add-container', (container) ->
    app.containerVM.prepend container
  
  @socket.on 'add-wbList', (wbList) ->
    app.wbListVM.removeAll()
    app.wbListVM.add n for n,i in wbList
