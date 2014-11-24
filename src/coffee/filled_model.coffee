class FilledModel
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  traverse = require 'traverse'
  Memory = require './memory'
  Utils = require './utils'
  Defaults = require './defaults'
  Converter = require './converter'
  HandlebarsMock = require './handlebars/mock'

  constructor: ->
    @fillAttributes()

  fillAttributes: ->
    @attributes = {}
    @fillFromEmptyMock()
    @fillFromMemory()
    @fillDefaults()

  fillDefaults: ->
    _this = @

    _.each Defaults.getAll(), (val, path_str) ->
      path = path_str.split('.')
      return if _this.existingValue(path)

      fn = val.match(/^{(.*)}$/)

      val = _this.defaultFunction(path_str, fn[1]) if fn
      _.deepSet(_this.attributes, path_str, val)

  defaultFunction: (path_str, fn) ->
    # TODO: replace state
    Converter.evalWithDependencies(fn)

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

    @overrideFromMemory(path)
    @addRelationIds(path)

  overrideFromMemory: (path) ->
    _this = @

    _.each @valueFromMemory(path), (val, key) ->
      _.deepSet(_this.attributes, "#{Utils.pathString(path)}.#{key}", val)

  addRelationIds: (path) ->
    _this = @

    _.each @existingValue(path), (val, key) ->
      return unless _.isObject(val) and !_.isArray(val)

      _this.addRelationId(path, key, val)

  addRelationId: (path, key, val) ->
    relation_id_path = "#{Utils.pathString(path)}.#{key}.#{@existingValue(path).model}_id"
    _.deepSet(@attributes, relation_id_path, @existingValue(path).id)

  fillElementary: (path) ->
    _.deepSet(@attributes, Utils.pathString(path), @valueFromMemory(path))

  valueFromMemory: (path) ->
    Memory.get(Utils.pathString(path))

  existingValue: (path) ->
    _.deepGet(@attributes, Utils.pathString(path))

module.exports = FilledModel
