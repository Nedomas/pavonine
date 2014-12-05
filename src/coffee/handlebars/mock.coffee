# this is injected into Handlebars templates so we don't have to
# do all the regex matching and putting variables ourselves
module.exports =
class HandlebarsMock
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require '../replacer'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  # return a stuctured object which is a
  # a list of all the variables registered via lookups
  # this can be dropped if we figure out how to get all the missing variables
  # from the compiled Handlebars template
  @get: ->
    result = {}

    _.each HandlebarsLookups.getIndividual(), (lookup) =>
      if @isAction(lookup)
        _.deepSet(result, lookup, "{#{Replacer.addAction(lookup)}}")
      else
        _.deepSet(result, lookup, "{#{Replacer.addState(lookup)}}")

    result

  # a structure of current step model in an object - will be filled with data
  # from backend
  @getEmpty: ->
    result = {}

    # Future fix: dont trash the namespace
    # lookups = _.without(HandlebarsLookups.getIndividual(),
    #   HandlebarsLookups.getOnContext()...)
    lookups = HandlebarsLookups.getIndividual()

    _.each lookups, (lookup) =>
      return if @isAction(lookup)

      _.deepSet(result, lookup, '')

    result

  @isAction: (lookup) ->
    _.include(HandlebarsHelpers.constant('actions'), _.last(lookup.split('.')))

  # scans DOM for defaultValues
  # TODO: should be moved out of here
  @scanDefaultValues: (code) ->
    # TODO: fix tests when this is commented out
    # $ = require 'jquery'
    # Defaults = require '../defaults'

    # _.each $(code).find('input[defaultValue]'), (el) ->
    #  value_binding = $(el).prop('value')
    #  path_str = value_binding.match('{this\.state\.(.*?)}')[1]
    #  val = $(el).attr('defaultValue')

    #  Defaults.save(path_str, val)
