class Model
  _ = require 'lodash'
  Memory = require './memory'
  MainModel = require './main_model'
  # KEYWORDS = ['model']

  constructor: (@attributes) ->
    @model = @attributes.model
    # @relationships = @attributes.relationships || []
    @plural = "#{@model}s"

    _this = @
    _.each @relationships, (relation) ->
      _this.attributes[relation] = Memory.get(relation)

  serialize: ->
    @attributes
    # result = _.omit(@attributes, KEYWORDS)

    # _this = @
    # debugger
#     _.each @relationships, (relationship) ->
#       key = relationship
#
#       result["#{key}_id"] = _this.attributes[relationship].id
#       result = _.omit(result, relationship)

    # result

  @main = ->
    new Model(MainModel.attributes())

module.exports = Model
