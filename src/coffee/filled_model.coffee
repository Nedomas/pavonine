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
    console.log 'after empty', _.pluck(@attributes.current_user.gym_sessions, 'squat')
    @fillFromMemory()
    console.log 'after memory', _.pluck(@attributes.current_user.gym_sessions, 'squat')

  fillFromEmptyMock: ->
    _this = @

    _.each traverse(HandlebarsMock.getEmpty()).paths(), (path) ->
      return unless path.length

      _.deepSet(_this.attributes, Utils.pathString(path), '')

  fillFromMemory: ->
    _this = @

    _.each traverse(@attributes).paths(), (path) ->
      _this.fillPath(path)

  fillPath: (path) ->
    return if _.isEmpty(@valueFromMemory(path))

    if _.isObject(@existingValue(path))
      @fillRelation(path)
    else
      @fillElementary(path)

  fillRelation: (path) ->
    _this = @

    _.each @valueFromMemory(path), (val, key) ->
      _.deepSet(_this.attributes, "#{Utils.pathString(path)}.#{key}", val)

    _.each @existingValue(path), (val, key) ->
      return unless _.isObject(val) and !_.isArray(val)

      relation_id_path = "#{Utils.pathString(path)}.#{key}.#{_this.existingValue(path).model}_id"
      _.deepSet(_this.attributes, relation_id_path, _this.existingValue(path).id)

  fillElementary: (path) ->
    _.deepSet(@attributes, Utils.pathString(path), @valueFromMemory(path))

  valueFromMemory: (path) ->
    Memory.get(Utils.pathString(path))

  existingValue: (path) ->
    _.deepGet(@attributes, Utils.pathString(path))

module.exports = FilledModel
