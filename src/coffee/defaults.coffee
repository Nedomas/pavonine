Defaults = (->
  _ = require 'lodash'
  _.mixin require('lodash-deep')

  data = {}

  save = (path, val) ->
    data[path] = val

  getAll = ->
    data

  return {
    save: save
    getAll: getAll
  }
)()

module.exports = Defaults
