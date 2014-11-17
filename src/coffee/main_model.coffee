class MainModel
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  traverse = require 'traverse'
  Memory = require './memory'
  HandlebarsMock = require './handlebars/mock'

  @attributes: ->
    result = {}
    @attributesFromEmptyMock(result)

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

  @attributesFromEmptyMock = (result) ->
    _.each traverse(HandlebarsMock.getEmpty()).paths(), (path) ->
      if path.length
        path_str = path.join('.')
        _.deepSet(result, path_str, '')

    result

module.exports = MainModel
