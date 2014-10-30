Handlebarser = (->
  Handlebars = require 'handlebars'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require './replacer'

  lookups = []
  array_lookups = []
  actions = ['create', 'update', 'destroy', 'previous', 'next', 'login']

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
      addArrayLookup(context.split('.'))
      iteration_result = options.fn(mock())
      iteration_result = Replacer.replace iteration_result,
        /{this\.state\.(.+?)}/, (attribute, initial) ->
          "{record.#{attribute}}"

      console.log iteration_result

      "{_.map(#{Replacer.toState(context.split('.'))}, function(record, i) {" +
      " return #{iteration_result}" +
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

  addLookup = (lookup) ->
    lookups.push(lookup)

  addArrayLookup = (lookup) ->
    array_lookups.push(lookup)
    addLookup(lookup)

  clean = ->
    lookups = []
    array_lookups = []

  getArrayLookups = ->
    array_lookups

  getLookups = ->
    lookups

  return {
    patch: patch
    mock: mock
    emptyMock: emptyMock
    clean: clean
    addLookup: addLookup
    getArrayLookups: getArrayLookups
    getLookups: getLookups
  }
)()

module.exports = Handlebarser
