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
      wrapped_state_ctx = wrapped_state(initial_ctx, ctx_id)
      raw_ctx = raw(initial_ctx, ctx_id)

      args = []
      _.each initial_args, (arg, i) ->
        args[i] = raw(initial_args[i], arg_ids[i])

      opts = {}
      opts.fn = initial_opts.fn(mock()) if initial_opts.fn
      opts.inverse = initial_opts.inverse(mock()) if initial_opts.inverse

      result = final_fn(raw_ctx, wrapped_state_ctx, args, opts)

      if result.match(/^<(.*)>$/)
        code = result
      else
        code = "\n<div>\n" +
        "{#{result}}\n" +
        "</div>"

      new Handlebars.SafeString code

  wrapped_state = (initial, from_ids) ->
    name = raw(initial, from_ids)
    result = wrapped(initial, from_ids)

    # remove earlier states
    result = result.replace("this.state.#{name}", name)

    result.replace(name, Replacer.addState(name))

  wrapped = (initial, from_ids) ->
    result = initial || from_ids
    result = result.toString()

    if div_match = result.match(/^<div>{(.*?)}<\/div>$/)
      result = div_match[1]
    else if braces_match = result.match(/^{(.*?)}$/)
      result = braces_match[1]

    result

  raw = (initial, from_ids) ->
    result = wrapped(initial, from_ids)

    if match = result.match(/\((.*?)\)/)
      [result, options...] = match[1].split(', ')
    else if initial
      if initial.match(/^{(.*)}$/)
        result = from_ids
      else
        result = "'#{result}'"
    else
      result = from_ids

    result.replace('this.state.', '')

  lodash = ->
    helpers = _.without(_.keys(_), constant('actions')...)

    _.each helpers, (method) ->
      register method, (raw_ctx, wrapped_ctx, args, opts) ->
        if opts.fn
          opts.fn.replace('this.state', "_.#{method}(#{wrapped_ctx})")
        else
          fn_args = [wrapped_ctx, args...]
          "_.#{method}(#{fn_args.join(', ')})"

  essential = ->
    register 'each', (raw_ctx, wrapped_ctx, args, opts) ->
      debugger
      HandlebarsLookups.addCollection(raw_ctx)

      each_iteration = Replacer.replace opts.fn,
        /this\.state\.(.+?)/, (attribute, initial) ->
          "record.#{attribute}"

      records_exist = "_.map(#{wrapped_ctx}, function(record, i) {" +
      " return #{each_iteration}" +
      ')'

      "#{wrapped_ctx}.length ? #{records_exist} : #{opts.inverse}"

#     Handlebars.registerHelper 'if', (context, options) ->
#       raw = rawSubject(context).split('.')
#       HandlebarsLookups.add(raw)
#       state_subject = Replacer.toState(raw)
#       fn = options.fn(mock())
#       inverse = options.inverse(mock())
#
#       "<div>{#{state_subject} ? #{fn} : #{inverse}}</div>"
#

    register 'with', (raw_ctx, wrapped_ctx, args, opts) ->
      result = Replacer.replace opts.fn, /{this\.state\.(.+?)}/g,
        (attribute, initial) ->

          path = [raw_ctx, attribute].join('.')
          HandlebarsLookups.add(raw_ctx)
          "{#{Replacer.addState(path)}}"

      result = Replacer.replace result, /{this\.action\,\ \'(.+?)\'}/g,
        (attribute, initial) ->
          path = [raw_ctx, attribute].join('.')
          "{#{Replacer.addAction(path)}}"

      result

#   rawSubject = (subject_string) ->
#     subject_string.replace('{', '').replace('}', '').replace('this.state.', '')
#
#   getSubject = (string) ->
#     if match = string.match(/\((.*?)\)/)
#       [result, options...] = match[1].replace('{', '').replace('}', '').split(', ')
#     else
#       result = string
#
#     result = result.replace('this.state.', '')
#     result.split('.')
#
#   getWrapper = (string) ->
#     regex = new RegExp "(.*?)#{getSubject(string).join('.')}(.*)"
#     matched = string.match(regex)
#
#     if matched
#       [before, after] = [matched[1].replace('{', '').replace('}', '')
#         .replace('this.state.', ''),
#         matched[2].replace('{', '').replace('}', '').replace('this.state.')]
#
#     (input) ->
#       before + input + after
#
  mock = ->
    HandlebarsMock = require './mock'
    HandlebarsMock.get()

  return {
    init: init
  }
)()

module.exports = HandlebarsHelpers
