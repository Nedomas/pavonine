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

  isAction = (lookup) ->
    _.include(HandlebarsHelpers.constant('actions'), _.last(lookup.split('.')))

  scanDefaultValues = (code) ->
    $ = require 'jquery'
    Defaults = require '../defaults'

# TODO
#     _.each $(code).find('input[defaultValue]'), (el) ->
#       value_binding = $(el).prop('value')
#       path_str = value_binding.match('{this\.state\.(.*?)}')[1]
#       val = $(el).attr('defaultValue')
#
#       Defaults.save(path_str, val)

  return {
    get: get
    getEmpty: getEmpty
    scanDefaultValues: scanDefaultValues
  }
)()

module.exports = HandlebarsMock
