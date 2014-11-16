HandlebarsLookups = (->
  individual = []
  collection = []

  add = (name) ->
    individual.push(name)

  addCollection = (name) ->
    create(name)
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
