HandlebarsMock = (->
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require '../replacer'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  get = ->
    result = {}

    _.each HandlebarsLookups.getIndividual(), (lookup) ->
      if isAction(lookup)
        _.deepSet(result, lookup, "{#{Replacer.addAction(lookup)}}")
      else
        _.deepSet(result, lookup, "{#{Replacer.addState(lookup)}}")

    result

  getEmpty = ->
    result = {}

    # Future fix: dont trash the namespace
    # lookups = _.without(HandlebarsLookups.getIndividual(),
    #   HandlebarsLookups.getOnContext()...)
    lookups = HandlebarsLookups.getIndividual()

    _.each lookups, (lookup) ->
      return if isAction(lookup)

      _.deepSet(result, lookup, '')

    result

  CONSTANTS =
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'login']

  constant = (name) ->
    CONSTANTS[name]

  isAction = (lookup) ->
    _.include(constant('actions'), _.last(lookup.split('.')))

  return {
    get: get
    getEmpty: getEmpty
  }
)()

module.exports = HandlebarsMock
