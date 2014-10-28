Model = module.exports = (->
  UI = require './ui'
  Memory = require './memory'
  Router = require './router'
  _ = require 'lodash'

  forBackend = (attributes, without_relations) ->
    main = _.omit(attributes, ['model', 'step'].concat(relationships()))
    related = []

    unless without_relations
      _.each relationships(), (relation) ->
        main["#{relation}_id"] = attributes[relation].id

      _.each relationships(), (relation) ->
        model_data = forBackend(attributes[relation], true)
        related.push(model_data.main)
        # TODO: Add nested relations

    { main: main, related: related }

  current = ->
    result = _.clone(Memory.get(name()))

    _.each relationships(), (relation) ->
      result[relation] = Memory.get(relation)

    result

  modelAttr = ->
    el = UI.element(step())
    el.attr('model')

  name = ->
    parsedModelAttr().name

  relationships = ->
    parsedModelAttr().relationships

  step = ->
    Router.current()

  parsedModelAttr = ->
    result = {}
    result.name = modelAttr(step()).match(/([a-zA-Z_]+)/)[1]

    relationships_string = modelAttr(step()).match(
      /[a-zA-Z_]+ for ([a-zA-Z_, ]+)/)?[1]
    result.relationships = relationships_string?.split(', ') || []

    result

  return {
    current: current
    name: name
    forBackend: forBackend
  }
)()
