window.HandlebarsMock = (->
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require '../replacer'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  get = ->
    result = {}

    _.each HandlebarsLookups.getIndividual(), (lookup) ->
      if isAction(lookup)
        _.deepSet(result, lookup, "{#{Replacer.toAction(lookup)}}")
      else
        _.deepSet(result, lookup, "{#{Replacer.toState(lookup)}}")

    result

  getEmpty = ->
    result = {}

    _.each HandlebarsLookups.getIndividual(), (lookup) ->
      unless isAction(lookup)
        _.deepSet(result, lookup, '')

    result

  CONSTANTS =
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'login']

  constant = (name) ->
    CONSTANTS[name]

  isAction = (lookup) ->
    _.include(constant('actions'), _.last(lookup))

  return {
    get: get
    getEmpty: getEmpty
  }
)()

module.exports = HandlebarsMock
