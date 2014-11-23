Data = (->
  _ = require 'lodash'
  Databound = require 'databound'

  HandlebarsLookups = require './handlebars/lookups'
  Memory = require './memory'
  DataLoader = require './data_loader'

  missingVariables = ->
    result = missingCollections()

    if used('current_user')
      result.push('current_user')

    _.uniq(result)

  missingCollections = ->
    result = []

    _.each HandlebarsLookups.getCollection(), (lookup) ->
      [owner, path...] = lookup.split('.')
      result.push(owner) unless Memory.has(owner)

    result

  used = (key) ->
    _.contains(HandlebarsLookups.getIndividual(), key)

  getMissing = ->
    return Databound::promise(true) if _.isEmpty(missingVariables())
    DataLoader.load(missingVariables())

  return {
    missingVariables: missingVariables
    getMissing: getMissing
  }
)()

module.exports = Data
