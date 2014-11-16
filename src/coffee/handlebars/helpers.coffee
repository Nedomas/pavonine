HandlebarsHelpers = (->
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  Replacer = require '../replacer'
  HandlebarsLookups = require './lookups'

  CONSTANTS =
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'login']

  constant = (name) ->
    CONSTANTS[name]

  init = ->
    lodash()
    essential()

  register = (method, final_fn) ->
    Handlebars.registerHelper method, ->
      [initial_ctx, initial_args..., initial_opts] = arguments
      [ctx_id, arg_ids...] = initial_opts.ids
      wrapped_ctx = wrapped(initial_ctx, ctx_id)
      raw_ctx = raw(initial_ctx, ctx_id)

      args = []
      _.each initial_args, (arg, i) ->
        args[i] = raw(initial_args[i] || arg_ids[i])

      # debugger
      opts = {}
      opts.fn = initial_opts.fn(mock()) if initial_opts.fn

      result = final_fn(raw_ctx, wrapped_ctx, args, opts)
      new Handlebars.SafeString "<div>{#{result}}</div>"

  wrapped = (initial, from_ids) ->
    result = initial || from_ids
    result = result.toString()

    if div_match = result.match(/^<div>{(.*?)}<\/div>$/)
      result = div_match[1]
    else if braces_match = result.match(/^{(.*?)}$/)
      result = braces_match[1]

    result

  raw = (initial, from_ids) ->
    result = if initial
      "'#{initial}'"
    else
      from_ids

    result.toString()

  lodash = ->
    helpers = _.without(_.keys(_), constant('actions')...)

    _.each helpers, (method) ->
      register method, (raw_ctx, wrapped_ctx, args, opts) ->
        if opts.fn
          "{#{opts.fn}}"
        else
          fn_args = [wrapped_ctx, args...]
          "_.#{method}(#{fn_args.join(', ')})"

#       Handlebars.registerHelper method, (context, options, data) ->
#         if _.isObject(options)
#           data = options
#
#         if context?.string
#           context = context.string
#
#         if options?.string
#           options = options.string
#
#         context = data.ids[0] unless _.isString(context)
#         options = data.ids[1] unless _.isString(options)
#
#         if _.isString(options)
#           result = new Handlebars.SafeString "_.#{method}(#{context}, '#{options}')"
#         else
#           result = "_.#{method}(#{context})"
#
#           if _.isFunction(data.fn)
#             subject = getSubject(context)
#             wrapper = getWrapper(context)
#
#             fn = data.fn(mock())
#             inverse = data.inverse(mock())
#             wrapped_subject = wrapper(Replacer.toState(subject))
#             new_wrapped_subject = "_.#{method}(#{wrapped_subject})"
#             fn = fn.replace('this.state', new_wrapped_subject)
#             result = new Handlebars.SafeString "<div>{#{fn}}</div>"
#
#         result

  essential = ->
    register 'each', (raw_ctx, wrapped_ctx, args, opts) ->
      HandlebarsLookups.addCollection(raw_ctx)

      each_iteration = Replacer.replace opts.fn,
        /{this\.state\.(.+?)}/, (attribute, initial) ->
          "{record.#{attribute}}"

      records_exist = "_.map(#{wrapped_ctx}, function(record, i) {" +
      " return #{each_iteration}" +
      '})'

      "#{wrapped_ctx}.length ? #{records_exist} : #{opts.inverse}"


#     Handlebars.registerHelper 'each', (context, options) ->
#       subject = getSubject(context)
#       wrapper = getWrapper(context)
#
#       # addArrayLookup(subject)
#       iteration_result = options.fn(mock())
#       iteration_result = Replacer.replace iteration_result,
#         /{this\.state\.(.+?)}/, (attribute, initial) ->
#           "{record.#{attribute}}"

      # collection = wrapper(Replacer.toState(subject))

#       fn = "_.map(#{collection}, function(record, i) {" +
#       " return #{iteration_result}" +
#       '})'
#
#       inverse = options.inverse(mock())
#       "<div>{#{collection}.length ? #{fn} : #{inverse}}</div>"

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
    HandlebarsMock = require './mock'
    HandlebarsMock.get()

  return {
    init: init
  }
)()

module.exports = HandlebarsHelpers
