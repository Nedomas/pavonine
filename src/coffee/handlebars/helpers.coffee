HandlebarsHelpers = (->
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  Replacer = require '../replacer'
  HandlebarsLookups = require './lookups'
  # HandlebarsMock = require './mock'

  CONSTANTS =
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'login']

  constant = (name) ->
    CONSTANTS[name]

  register = ->
    lodash()
    essential()

  lodash = ->
    helpers = _.without(_.keys(_), constant('actions')...)

    _.each helpers, (method) ->
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

  essential = ->
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
      HandlebarsLookups.add(raw)
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
        HandlebarsLookups.add(updated_path)
        "{#{Replacer.toState(updated_path)}}"

      result = Replacer.replace result, /this\.action\,\ \'(.+?)\'/g, (attribute, initial) ->
        updated_path = context_path.concat(attribute.split('.'))
        HandlebarsLookups.add(updated_path)
        "#{Replacer.toAction(updated_path)}"

      "<div>#{result}</div>"

  rawSubject = (subject_string) ->
    subject_string.replace('{', '').replace('}', '').replace('this.state.', '')

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

  mock = ->
    HandlebarsMock.get()

  return {
    register: register
  }
)()

module.exports = HandlebarsHelpers
