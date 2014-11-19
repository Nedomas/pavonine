window.Cornflake = Cornflake = module.exports = (->
  Persistance = require './persistance'
  HandlebarsManager = require './handlebars/manager'
  Router = require './router'
  Facebook = require './facebook'

  init = ->
    HandlebarsManager::init()
    configure()
    Router.change(1)
    Facebook.init()

  configure = ->
    Persistance.setApi(window.PAVONINE_SERVER)

  return {
    init: init
  }
)()

Cornflake.init()
