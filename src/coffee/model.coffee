class Model
  _ = require 'lodash'
  Memory = require './memory'
  MainModel = require './main_model'

  constructor: (@attributes) ->
    @model = @attributes.model
    @plural = "#{@model}s"

  serialize: ->
    _.merge(@attributes, app_token: window.PAVONINE_APP)

  @main = ->
    new Model(MainModel.attributes())

module.exports = Model
