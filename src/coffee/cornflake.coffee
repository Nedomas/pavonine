window.Cornflake = Cornflake = module.exports = (->
  Persistance = require './persistance'
  HandlebarsManager = require './handlebars/manager'
  Router = require './router'
  Facebook = require './facebook'

  init = ->
    console.log('Here and now')
    HandlebarsManager.init()
    configure()
    Router.change(1)
    Facebook.init()

  configure = ->
    # Persistance.setApi('http://cornflake-backend.herokuapp.com')
    Persistance.setApi(window.PAVONINE_SERVER)

  return {
    init: init
  }
)()

Cornflake.init()
