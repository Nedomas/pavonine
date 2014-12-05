# Wrapper around Filled model for sweeter API
# Probably will wrap Data later aswell
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
