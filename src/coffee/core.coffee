class Core
  HandlebarsManager = require './handlebars/manager'
  Router = require './router'

  @init: ->
    # patches Handlebars helpers for our purposes
    HandlebarsManager.init()
    # renders step 1
    Router.change(1)

# page is already loaded when this is inited
Core.init()
module.exports = Core
