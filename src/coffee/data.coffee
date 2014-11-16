Data = (->
  _ = require 'lodash'
  HandlebarsLookups = require './handlebars/lookups'
  Memory = require './memory'

  missingVariables = ->
    result = []
    if used('current_user') and !loggedIn()
      result.push('current_user')

    _.each HandlebarsLookups.getCollection(), (lookup) ->
      array_name = lookup[0]
      result.push(array_name) unless Memory.has(array_name)

    result

  missing = ->
    !_.isEmpty(missingVariables())

  used = (key) ->
    _.any HandlebarsLookups.getIndividual(), (lookup) ->
      lookup[0] == key

  loggedIn = ->
    Memory.has('current_user')

  return {
    missing: missing
    missingVariables: missingVariables
  }
)()

module.exports = Data
