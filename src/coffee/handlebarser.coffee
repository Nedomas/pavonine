Handlebarser = (->
  Handlebars = require 'handlebars'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require './replacer'

  lookups = []
  actions = ['create', 'update', 'destroy', 'previous', 'next']

  patch = ->
    Handlebars.JavaScriptCompiler::nameLookup = (parent, name, type) ->
      _.each @environment.opcodes, (opcode) ->
        if opcode.opcode == 'lookupOnContext'
          lookup = opcode.args[0]
          lookups.push(lookup)

      if Handlebars.JavaScriptCompiler.isValidJavaScriptVariableName(name)
        "#{parent}.#{name}"
      else
        parent + "['" + name + "']"

    Handlebars.registerHelper 'each', (context, options) ->
      iteration_result = options.fn(mock())
      iteration_result = Replacer.replace iteration_result,
        /{this\.state\.(.+?)}/, (attribute, initial) ->
          "' + record.#{attribute} + '"

      "{_.map(#{Replacer.toState(context.split('.'))}, function(record, i) {" +
      " return '#{iteration_result}'" +
      '})}'

  mock = ->
    result = {}
    _.each lookups, (lookup) ->
      if isAction(lookup)
        _.deepSet(result, lookup, "{#{Replacer.toAction(lookup)}}")
      else
        _.deepSet(result, lookup, "{#{Replacer.toState(lookup)}}")

    result

  emptyMock = ->
    result = {}
    _.each lookups, (lookup) ->
      unless isAction(lookup)
        _.deepSet(result, lookup, '')

    result

  isAction = (lookup) ->
    _.include(actions, _.last(lookup))

  return {
    patch: patch
    mock: mock
    emptyMock: emptyMock
  }
)()

module.exports = Handlebarser
