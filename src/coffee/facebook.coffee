Facebook = (->
  $ = require 'jquery'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Router = require './router'
  Memory = require './memory'
  Persistance = require './persistance'

  init = ->
    $.ajaxSetup
      cache: true
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
      FB.init
        appId: '776916785684160'
        xfbml: true
        version: 'v2.1'

  loggedIn = (resp) ->
    access_token = _.deepGet(resp, 'authResponse.accessToken')

    attributes =
      access_token: access_token
      model: 'current_user'

    Persistance.communicate('create', attributes).then (current_user) ->
      Memory.setForever(current_user.attributes)
      Router.goOn()

  login = ->
    FB.login(loggedIn, scope: 'user_about_me')

  return {
    init: init
    login: login
  }
)()

module.exports = Facebook
