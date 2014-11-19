Facebook = (->
  $ = require 'jquery'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Router = require './router'
  Memory = require './memory'
  Persistance = require './persistance'

  ensureInit = ->
    deferred = $.Deferred()
    _.once(init)(deferred)
    deferred.promise()

  init = (deferred) ->
    $.ajaxSetup
      cache: true
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
      FB.init
        appId: window.PAVONINE_FB_APP_ID
        xfbml: true
        version: 'v2.1'

      deferred.resolve true


  loggedIn = (resp) ->
    access_token = _.deepGet(resp, 'authResponse.accessToken')

    attributes =
      access_token: access_token
      model: 'current_user'

    Persistance.communicate('create', attributes).then (current_user) ->
      Memory.setForever(current_user.attributes)
      Router.goOn()

  login = ->
    ensureInit().then ->
      FB.login(loggedIn, scope: 'user_about_me')

  return {
    login: login
  }
)()

module.exports = Facebook
