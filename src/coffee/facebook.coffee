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

  loggedIn = (r) ->
    console.log r
    debugger

  login = ->
    FB.login(loggedIn, scope: 'user_about_me')

  return {
    init: init
    login: login
  }
)()

module.exports = Facebook
