HandlebarsLookups = (->
  _ = require 'lodash'
  individual = []
  collection = []

  add = (name) ->
    debugger if _.isArray(name)
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

  return {
    add: add
    addCollection: addCollection
    clean: clean
    getIndividual: getIndividual
    getCollection: getCollection
  }
)()

module.exports = HandlebarsLookups
