window.Cornflake = Cornflake = module.exports = (->
  Router = require './router'

  init = ->
    console.log('Here and now')
    configure()
    Router.change(1)
    # Facebook.init()

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

Facebook = (->
  $ = require 'jquery'

  init = ->
    $.ajaxSetup
      cache: true
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
      FB.init
        appId: '776916785684160'
        xfbml: true
        version: 'v2.1'
      FB.login(loggedIn, scope: 'user_about_me')

  loggedIn = (r) ->
    console.log r
    debugger

  return {
    init: init
  }
)()
