
class ContainerViewModel
  constructor: ->
    @items = ko.observableArray([])
    
  add: (item) ->
    @items.push item

class WbListViewModel
  constructor: ->
    @items = ko.observableArray([])
    
  add: (item) ->
    @items.push item

app.c.ContainerViewModel = ContainerViewModel
app.c.WbListViewModel    = WbListViewModel