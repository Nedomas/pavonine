Model = module.exports = (->
  UI = require './ui'
  Memory = require './memory'

  save = (step, data) ->

  forStep = (step) ->
    Memory.get(step - 1, modelAttr(step))
    na = parsedName(step)
    debugger
#
#     if result.model
#       relationship_hash = {}
#       relationship_hash[result.model] = _.clone(result)
#       _.extend(result, relationship_hash)
#
#     result

  modelAttr = (step) ->
    el = UI.element(step)
    el.attr('model')

  record = (step) ->
    { name: modelAttr() }

  name = (step) ->
    # 'message'
    debugger

  relationships = (step) ->
    # ['subscriber']
    debugger

  parsedName = (step) ->
    # message for subscri
    relationships_string = modelAttr(step).match(
      /[a-zA-Z_]+ for ([a-zA-Z_, ]+)/)?[1]
    name = modelAttr(step).match(/([a-zA-Z_]+)/)[1]
    relationships = relationships_string.split(', ')
    { name: name, relationships: relationships }

  return {
    forStep: forStep
  }
)()
