class Model
  FilledModel = require './filled_model'

  constructor: (@attributes) ->
    @model = @attributes.model
    @plural = "#{@model}s"

  serialize: ->
    @attributes

  @filled = ->
    filled = new FilledModel
    new Model(filled.attributes)

module.exports = Model
