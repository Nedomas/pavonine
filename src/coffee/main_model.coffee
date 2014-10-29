class MainModel
  _ = require 'lodash'
  UI = require './ui'
  Memory = require './memory'
  Router = require './router'

  ALPHANUMERIC_WORD = /([a-zA-Z_]+)/
  MODEL_WITH_RELATIONSHIPS = /[a-zA-Z_]+ for ([a-zA-Z_, ]+)/

  @constructor: ->

  @attributes: ->
    result = Memory.get(@mname())

    if _.isEmpty(result)
      result = _.assign(result, @metadata())

    result

  @metadata: ->
    model: @mname()
    step: @step()
    relationships: @relationships()

  @modelAttr: ->
    el = UI.element(@step())
    el.attr('model')

  # so it does not collide with Object.name
  @mname: ->
    @modelAttr().match(ALPHANUMERIC_WORD)[1]

  @relationships: ->
    relationships_string = @modelAttr().match(MODEL_WITH_RELATIONSHIPS)?[1]
    relationships_string?.split(', ') || []

  @step: ->
    Router.current()

module.exports = MainModel
