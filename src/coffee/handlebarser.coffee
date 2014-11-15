Handlebarser = (->
  Handlebars = require 'handlebars'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Replacer = require './replacer'

  lookups = []
  array_lookups = []
  actions = ['create', 'update', 'destroy', 'previous', 'next', 'login']

  getSubject = (string) ->
    if match = string.match(/\((.*?)\)/)
      [result, options...] = match[1].replace('{', '').replace('}', '').split(', ')
    else
      result = string

    result = result.replace('this.state.', '')
    result.split('.')

  getWrapper = (string) ->
    regex = new RegExp "(.*?)#{getSubject(string).join('.')}(.*)"
    matched = string.match(regex)

    if matched
      [before, after] = [matched[1].replace('{', '').replace('}', '')
        .replace('this.state.', ''),
        matched[2].replace('{', '').replace('}', '').replace('this.state.')]

    (input) ->
      before + input + after

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

    BLACKLISTED = ['create']
    LODASH_ACCESSED_KEYS = _.without(_.keys(_), BLACKLISTED...)

#   PMAX problem
#     _.each LODASH_ACCESSED_KEYS, (method) ->
#       Handlebars.registerHelper "p#{method}", (context, options) ->
#         subject = getSubject(context)
#         wrapper = getWrapper(context)
#         wrapped_subject = wrapper(Replacer.toState(subject))
#
#         if _.isString(options)
#           "{_.#{method}(#{wrapped_subject}, '#{options}')}"
#         else
#           "{_.#{method}(#{wrapped_subject})}"

    _.each LODASH_ACCESSED_KEYS, (method) ->
      Handlebars.registerHelper method, (context, options, data) ->
        if _.isObject(options)
          data = options

        if context?.string
          context = context.string

        if options?.string
          options = options.string

        context = data.ids[0] unless _.isString(context)
        options = data.ids[1] unless _.isString(options)

        if _.isString(options)
          result = new Handlebars.SafeString "_.#{method}(#{context}, '#{options}')"
        else
          result = "_.#{method}(#{context})"

          if _.isFunction(data.fn)
            subject = getSubject(context)
            wrapper = getWrapper(context)

            fn = data.fn(mock())
            inverse = data.inverse(mock())
            wrapped_subject = wrapper(Replacer.toState(subject))
            new_wrapped_subject = "_.#{method}(#{wrapped_subject})"
            fn = fn.replace('this.state', new_wrapped_subject)
            result = new Handlebars.SafeString "<div>{#{fn}}</div>"

        result

    Handlebars.registerHelper 'each', (context, options) ->
      subject = getSubject(context)
      wrapper = getWrapper(context)

      addArrayLookup(subject)
      iteration_result = options.fn(mock())
      iteration_result = Replacer.replace iteration_result,
        /{this\.state\.(.+?)}/, (attribute, initial) ->
          "{record.#{attribute}}"

      collection = wrapper(Replacer.toState(subject))

      fn = "_.map(#{collection}, function(record, i) {" +
      " return #{iteration_result}" +
      '})'

      inverse = options.inverse(mock())
      "<div>{#{collection}.length ? #{fn} : #{inverse}}</div>"

    Handlebars.registerHelper 'if', (context, options) ->
      raw = rawSubject(context).split('.')
      addLookup(raw)
      state_subject = Replacer.toState(raw)
      fn = options.fn(mock())
      inverse = options.inverse(mock())

      "<div>{#{state_subject} ? #{fn} : #{inverse}}</div>"

    Handlebars.registerHelper 'with', (context, options) ->
      context = options.ids[0] unless _.isString(context)
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
