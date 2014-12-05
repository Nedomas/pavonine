StepMemory = require './step_memory'

class LocalMemory
  @set: (data) ->
    localStorage[data.model] = JSON.stringify(data)

  @get: (model) ->
    json = localStorage[model]
    return unless json

    data = JSON.parse(json)
    StepMemory.set(data)

module.exports = LocalMemory
