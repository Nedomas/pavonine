# handles Facebook login
class Facebook
  $ = require 'jquery'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Router = require './router'
  LocalMemory = require './local_memory'
  Persistance = require './persistance'

  @ensureInit: ->
    deferred = $.Deferred()
    _.once(@init)(deferred)
    deferred.promise()

  @init: (deferred) ->
    $.ajaxSetup
      cache: true
    $.getScript 'https://connect.facebook.net/en_UK/all.js', ->
      FB.init
        appId: window.PAVONINE_FB_APP_ID
        xfbml: true
        version: 'v2.1'

      deferred.resolve true

  @loggedIn: (resp) ->
    access_token = _.deepGet(resp, 'authResponse.accessToken')

    attributes =
      access_token: access_token
      model: 'current_user'

    Persistance.communicate('create', attributes).then (current_user) ->
      LocalMemory.set(current_user.attributes)
      Router.goOn()

  @login: ->
    @ensureInit().then =>
      FB.login(@loggedIn, scope: 'user_about_me')

module.exports = Facebook
