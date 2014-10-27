window.Cornflake = Cornflake = module.exports = (->
  Router = require './router'

  init = ->
    console.log('Here and now')
    configure()
    Router.change(1)

  configure = ->
    Persistance = require './persistance'
    # Persistance.setApi('http://cornflake-backend.herokuapp.com')
    Persistance.setApi('http://10.30.0.1:3000')
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))

  return {
    init: init
  }
)()

window.onload = ->
  Cornflake.init()
