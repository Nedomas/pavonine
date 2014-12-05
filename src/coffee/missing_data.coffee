# manages missing data list
class MissingData
  _ = require 'lodash'
  Databound = require 'databound'

  HandlebarsLookups = require './handlebars/lookups'
  Memory = require './memory'
  DataLoader = require './data_loader'

  @collections: ->
    result = []

    _.each HandlebarsLookups.getCollection(), (lookup) ->
      [owner, path...] = lookup.split('.')
      result.push(owner) unless Memory.has(owner)

    result.push('current_user') if @used('current_user')
    _.uniq(result)

  @used: (key) ->
    _.contains(HandlebarsLookups.getIndividual(), key)

  @get: ->
    return Databound::promise(true) if _.isEmpty(@collections())

    DataLoader.load(@collections())

module.exports = MissingData
