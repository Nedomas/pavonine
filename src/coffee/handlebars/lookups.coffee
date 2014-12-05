# stores all lookups that were registered with Handlebars helpers
# so we know what data is missing
class HandlebarsLookups
  _ = require 'lodash'
  individual = []
  collection = []
  on_context = []

  @add: (name) ->
    individual.push(name)

  @addCollection: (name) ->
    @add(name)
    collection.push(name)

  @clean: ->
    individual = []
    collection = []

  @getIndividual: ->
    individual

  @getCollection: ->
    collection

  @addOnContext: (name) ->
    @add(name)
    on_context.push(name)

  @getOnContext: ->
    on_context

module.exports = HandlebarsLookups
