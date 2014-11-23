HandlebarsLookups = (->
  _ = require 'lodash'
  individual = []
  collection = []
  on_context = []

  add = (name) ->
    individual.push(name)

  addCollection = (name) ->
    add(name)
    collection.push(name)

  clean = ->
    individual = []
    collection = []

  getIndividual = ->
    individual

  getCollection = ->
    collection

  addOnContext = (name) ->
    add(name)
    on_context.push(name)

  getOnContext = ->
    on_context

  return {
    add: add
    addCollection: addCollection
    clean: clean
    getIndividual: getIndividual
    getCollection: getCollection
    addOnContext: addOnContext
    getOnContext: getOnContext
  }
)()

module.exports = HandlebarsLookups
