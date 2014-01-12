
class ContainerViewModel
  constructor: ->
    @items = ko.observableArray []
  
  prepend: (item) -> @items.unshift item
  append:  (item) -> @items.push    item

class WbListViewModel
  constructor: ->
    @items = ko.observableArray []
    @types = ko.observableArray ['domain', 'url']
    
  add: (item) ->   @items.push item
  removeAll: () -> @items.removeAll()
  
  change: (item) =>
    console.log item
    app.socket.emit 'replace-wbListItem', item
    
    return true
  
  new: (item) ->
    app.socket.emit 'new-wbListItem', item
    @add item

app.c.ContainerViewModel = ContainerViewModel
app.c.WbListViewModel    = WbListViewModel
