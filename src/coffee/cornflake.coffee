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
    Persistance.setApi('http://10.30.0.1:3000')
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))

  return {
    init: init
  }
)()

Cornflake.init()
