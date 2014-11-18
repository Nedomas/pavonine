Data = (->
  _ = require 'lodash'
  HandlebarsLookups = require './handlebars/lookups'
  Databound = require 'databound'
  Memory = require './memory'
  $ = require 'jquery'

  missingVariables = ->
    result = []
    if used('current_user') and !loggedIn()
      result.push('current_user')

    _.each HandlebarsLookups.getCollection(), (lookup) ->
      [owner, path...] = lookup.split('.')
      result.push(owner) unless Memory.has(owner)

    _.uniq(result)

  missing = ->
    !_.isEmpty(missingVariables())

  used = (key) ->
    _.any HandlebarsLookups.getIndividual(), (lookup) ->
      lookup == key

  loggedIn = ->
    Memory.has('current_user')

  getMissing = ->
    $.when(_.map(missingVariables(), (variable) -> get(variable))...)

  get = (name) ->
    Persistance = require './persistance'

    if name == 'current_user'
      if attributes = Memory.getForever('current_user')
        for_request = _.pick(attributes, 'id', 'access_token', 'model')

        Persistance.communicate('update', for_request).then (current_user) ->
          Memory.setForever(current_user.attributes)
          Databound::promise(true)
      else
        failedPromise('login')
    else
      attributes =
        model: singularize(name)

      Persistance.communicate('where', attributes)

  singularize = (string) ->
    string.replace(/s$/, '')

  failedPromise = (result) ->
    deferred = $.Deferred()
    deferred.reject result
    deferred.promise()

  return {
    missing: missing
    missingVariables: missingVariables
    getMissing: getMissing
  }
)()

module.exports = Data
