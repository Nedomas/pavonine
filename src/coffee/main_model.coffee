class MainModel
  _ = require 'lodash'
  UI = require './ui'
  Memory = require './memory'
  Router = require './router'
  Handlebarser = require './handlebarser'
  traverse = require 'traverse'

  @constructor: ->

  @attributes: ->
    result = {}
    @setEmptyFromMock(result)

    _.each traverse(result).paths(), (path) ->
      path_str = path.join('.')
      value = Memory.get(path_str)

      unless _.isEmpty(value)
        existing = _.deepGet(result, path_str)

        if _.isObject(existing)
          _.each value, (val, key) ->
            _.deepSet(result, "#{path_str}.#{key}", val)

          _.each existing, (val, key) ->
            if _.isObject(val) and !_.isArray(val)
              relation_id_path = "#{path_str}.#{key}.#{value.model}_id"
              _.deepSet(result, relation_id_path, value.id)
        else
          _.deepSet(result, path_str, value)

    result

  @setEmptyFromMock = (result) ->
    _.each traverse(Handlebarser.emptyMock()).paths(), (path) ->
      if path.length
        path_str = path.join('.')
        _.deepSet(result, path_str, '')

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
