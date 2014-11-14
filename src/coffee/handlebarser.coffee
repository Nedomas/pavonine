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
      [sort_column, sort_by] = options.hash.sortBy.split(' ')
      sort_column ||= 'created_at'
      sort_by ||= 'ASC'

      addArrayLookup(context.split('.'))
      iteration_result = options.fn(mock())
      iteration_result = Replacer.replace iteration_result,
        /{this\.state\.(.+?)}/, (attribute, initial) ->
          "{record.#{attribute}}"

      iteration_subject = Replacer.toState(context.split('.'))
      sorted_subject = "_.sortBy(#{iteration_subject}, '#{sort_column}')"
      sorted_subject += ".reverse()" if sort_by == 'DESC'

      fn = "_.map(#{sorted_subject}, function(record, i) {" +
      " return #{iteration_result}" +
      '})'

      inverse = options.inverse(mock())
      "<div>{#{sorted_subject}.length ? #{fn} : #{inverse}}</div>"

    Handlebars.registerHelper 'if', (context, options) ->
      raw = rawSubject(context).split('.')
      addLookup(raw)
      state_subject = Replacer.toState(raw)
      fn = options.fn(mock())
      inverse = options.inverse(mock())

      "<div>{#{state_subject} ? #{fn} : #{inverse}}</div>"

    Handlebars.registerHelper 'with', (context, options) ->
      fn = options.fn(mock())
      context_path = context.split('.')

      result = Replacer.replace fn, /{this\.state\.(.+?)}/g, (attribute, initial) ->
        updated_path = context_path.concat(attribute.split('.'))
        addLookup(updated_path)
        "{#{Replacer.toState(updated_path)}}"

      result = Replacer.replace result, /this\.action\,\ \'(.+?)\'/g, (attribute, initial) ->
        updated_path = context_path.concat(attribute.split('.'))
        addLookup(updated_path)
        "#{Replacer.toAction(updated_path)}"

      "<div>#{result}</div>"

  rawSubject = (subject_string) ->
    subject_string.replace('{', '').replace('}', '').replace('this.state.', '')

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
