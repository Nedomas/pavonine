DataLoader = (->
  Databound = require 'databound'
  $ = require 'jquery'
  _ = require 'lodash'

  Persistance = require './persistance'
  Utils = require './utils'
  Memory = require './memory'

  load = (missings) ->
    $.when(_.map(missings, (missing) -> loadSingle(missing))...)

  loadSingle = (name) ->
    return loadCurrentUser() if name == 'current_user'

    attributes =
      model: Utils.singularize(name)

    Persistance.communicate('where', attributes)

  loadCurrentUser = ->
    return Utils.failedPromise('login') unless currentUserTokens()

    Persistance.communicate('update', currentUserTokens()).then (current_user) ->
      Memory.setForever(current_user.attributes)
      Databound::promise(true)

  currentUserTokens = ->
    from_storage = Memory.getForever('current_user')
    return if _.isEmpty(from_storage)

    _.pick(from_storage, 'id', 'access_token', 'model')

  return {
    load: load
  }
)()

module.exports = DataLoader
