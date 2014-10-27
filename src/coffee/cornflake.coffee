window.Cornflake = Cornflake = module.exports = (->
  UI = require './ui'

  init = ->
    console.log('Here and now')
    initializers()
    UI.state(1)

  initializers = ->
    Persistance = require './persistance'
    Persistance.setApi('http://cornflake-backend.herokuapp.com')
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))

  return {
    init: init
  }
)()

window.onload = ->
  Cornflake.init()
