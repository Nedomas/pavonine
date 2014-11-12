class Model
  _ = require 'lodash'
  Memory = require './memory'
  MainModel = require './main_model'

  constructor: (@attributes) ->
    @model = @attributes.model
    @plural = "#{@model}s"

  serialize: ->
    @attributes

  @main = ->
    new Model(MainModel.attributes())

module.exports = Model
