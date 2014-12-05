# persistance of all default values of fields (defaultValue in DOM)
class Defaults
  data = {}

  @save: (path, val) ->
    data[path] = val

  @getAll: ->
    data

module.exports = Defaults
