# loads missing collections from the backend
class DataLoader
  Databound = require 'databound'
  $ = require 'jquery'
  _ = require 'lodash'

  Persistance = require './persistance'
  Utils = require './utils'
  LocalMemory = require './local_memory'

  # launches a seperate request for each collection
  @load: (missings) ->
    $.when(_.map(missings, (missing) => @loadSingle(missing))...)

  @loadSingle: (name) ->
    return @loadCurrentUser() if name == 'current_user'

    attributes =
      model: Utils.singularize(name)

    Persistance.communicate('where', attributes)

  @loadCurrentUser: ->
    return Utils.failedPromise('login') unless @currentUserTokens()

    Persistance.communicate('update', @currentUserTokens()).then (current_user) ->
      LocalMemory.set(current_user.attributes)
      Databound::promise(true)

  @currentUserTokens: ->
    from_storage = LocalMemory.get('current_user')
    return if _.isEmpty(from_storage)

    _.pick(from_storage, 'id', 'access_token', 'model')

module.exports = DataLoader
