
class ContainerViewModel
  constructor: ->
    @items = ko.observableArray([])
    
  add: (item) ->
    @items.push item

app.c.ContainerViewModel = ContainerViewModel