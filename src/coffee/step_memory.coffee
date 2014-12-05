# works as a short-term memory which holds data for the current step
class StepMemory
  app_data = {}

  @set: (data) ->
    app_data[data.model] = data

  @setArray: (name, records) ->
    app_data[name] = records

  @get = (model) ->
    app_data[model]

  @getAll = ->
    app_data

  @has = (key) ->
    !!app_data[key]

  @clean = ->
    app_data = {}

module.exports = StepMemory
