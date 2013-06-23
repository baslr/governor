
($ document).ready ->
  $.ajaxSetup cache:false
  
  app.boil ['container Container tbody#table']
