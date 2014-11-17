Data = (->
  _ = require 'lodash'
  HandlebarsLookups = require './handlebars/lookups'
  Memory = require './memory'

  missingVariables = ->
    result = []
    if used('current_user') and !loggedIn()
      result.push('current_user')

    _.each HandlebarsLookups.getCollection(), (lookup) ->
      [owner, path...] = lookup.split('.')
      result.push(owner) unless Memory.has(owner)

    result

  missing = ->
    !_.isEmpty(missingVariables())

  used = (key) ->
    _.any HandlebarsLookups.getIndividual(), (lookup) ->
      lookup == key

  loggedIn = ->
    Memory.has('current_user')

  return {
    missing: missing
    missingVariables: missingVariables
  }
)()

module.exports = Data
