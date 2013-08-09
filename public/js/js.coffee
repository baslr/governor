
($ document).ready ->
  $.ajaxSetup cache:false
  
  app.boil ['container Container tbody#table', 'wbList WbList tbody#wbList']
  
  ($ 'BUTTON#btnNewWbItem').click ->
    app.wbListVM.new {s:'example', type:'domain', 'list':'white', id:new Date().getTime()}