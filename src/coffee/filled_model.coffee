class FilledModel
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  traverse = require 'traverse'
  Memory = require './memory'
  Utils = require './utils'
  HandlebarsMock = require './handlebars/mock'

  constructor: ->
    @fillAttributes()

  fillAttributes: ->
    @attributes = {}
    @fillFromEmptyMock()
    @fillFromMemory()

  fillFromEmptyMock: ->
    _this = @

    _.each traverse(HandlebarsMock.getEmpty()).paths(), (path) ->
      return unless path.length
      _.deepSet(_this.attributes, Utils.pathString(path), '')

  fillFromMemory: ->
    _this = @
    _.each traverse(@attributes).paths(), (path) ->
      value = Memory.get(Utils.pathString(path))

      unless _.isEmpty(value)
        existing = _.deepGet(_this.attributes, Utils.pathString(path))

        if _.isObject(existing)
          debugger if Utils.pathString(path) == 'current_user.gym_sessions'
          _.each value, (val, key) ->
            _.deepSet(_this.attributes, "#{Utils.pathString(path)}.#{key}", val)

          _.each existing, (val, key) ->
            if _.isObject(val) and !_.isArray(val)
              relation_id_path = "#{Utils.pathString(path)}.#{key}.#{value.model}_id"
              _.deepSet(_this.attributes, relation_id_path, value.id)
        else
          _.deepSet(_this.attributes, Utils.pathString(path), value)

module.exports = FilledModel
