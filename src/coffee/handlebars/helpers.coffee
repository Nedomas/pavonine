HandlebarsHelpers = (->
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  Replacer = require '../replacer'
  LodashHelpers = require './lodash_helpers'
  BaseHelpers = require './base_helpers'
  MomentHelpers = require './moment_helpers'

  CONSTANTS =
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'login']

  constant = (name) ->
    CONSTANTS[name]

  init = ->
    LodashHelpers.register()
    BaseHelpers.register()
    MomentHelpers.register()

  register = (method, final_fn) ->
    Handlebars.registerHelper method, ->
      [initial_ctx, initial_args..., initial_opts] = arguments
      [ctx_id, arg_ids...] = initial_opts.ids
      wrapped_state_ctx = wrapped_state(initial_ctx, ctx_id)
      raw_ctx = raw(initial_ctx, ctx_id)

      args = []
      _.each initial_args, (arg, i) ->
        args[i] = raw(initial_args[i], arg_ids[i])

      args.push(initial_opts.hash) unless _.isEmpty(_.keys(initial_opts.hash))

      # data = Handlebars.createFrame(initial_opts.data)
      # data.contextPath = Handlebars.Utils.appendContextPath(data.contextPath, 'foo')
      # initial_opts.data = data

      opts = {}
      # TODO: Cant require outside method
      HandlebarsMock = require './mock'
      opts.fn = initial_opts.fn(HandlebarsMock.get()) if initial_opts.fn
      opts.inverse = initial_opts.inverse(HandlebarsMock.get()) if initial_opts.inverse

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

    if div_match = result.match(/<div>\n{(.*?)}\n<\/div>/)
      result = div_match[1]
    else if braces_match = result.match(/^{(.*?)}$/)
      result = braces_match[1]

    result

  raw = (initial, from_ids) ->
    result = wrapped(initial, from_ids)

    if match = result.match(/\((.*?)\)/)
      [result, options...] = match[1].split(', ')
    else if _.isString(initial)
      if initial.match(/^{(.*)}$/)
        result = from_ids
      else
        result = "'#{result}'"
    else
      result = from_ids

    result.replace('this.state.', '')

  return {
    init: init
    constant: constant
    register: register
  }
)()

module.exports = HandlebarsHelpers
