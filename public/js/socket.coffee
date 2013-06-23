
app.initSocketMessages = ->
  @socket.on 'add-container', (container) ->
    app.containerVM.add container