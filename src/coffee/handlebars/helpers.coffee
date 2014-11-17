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
    moment()

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

      data = Handlebars.createFrame(initial_opts.data)
      data.contextPath = Handlebars.Utils.appendContextPath(data.contextPath, 'foo')
      initial_opts.data = data

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

  lodash = ->
    helpers = _.without(_.keys(_), constant('actions')...)

    _.each helpers, (method) ->
      register method, (raw_ctx, wrapped_ctx, args, opts) ->
        if opts.fn
          opts.fn.replace('this.state', "_.#{method}(#{wrapped_ctx})")
        else
          fn_args = [wrapped_ctx, args...]
          "_.#{method}(#{fn_args.join(', ')})"

  moment = ->
    register 'moment', (raw_ctx, wrapped_ctx, args, opts) ->
      methods = []

      _.each args[0], (param, method) ->
        methods.push("#{method}('#{param}')")

      "moment(#{wrapped_ctx}).#{methods.join('.')}"

  essential = ->
    register 'each', (raw_ctx, wrapped_ctx, args, opts) ->
      HandlebarsLookups.addCollection(raw_ctx)

      each_iteration = Replacer.replace opts.fn,
        /this\.state\.(.+?)/, (attribute, initial) ->
          "record.#{attribute}"

      records_exist = "_.map(#{wrapped_ctx}, function(record, i) {\n" +
      " return #{each_iteration}\n" +
      '})'

      if opts.inverse
        "#{wrapped_ctx}.length ? (#{records_exist}) : (#{opts.inverse})"
      else
        records_exist

    register 'if', (raw_ctx, wrapped_ctx, args, opts) ->
      "#{wrapped_ctx} ? #{opts.fn} : #{opts.inverse || null}"

    register 'with', (raw_ctx, wrapped_ctx, args, opts) ->
      result = Replacer.replace opts.fn, /{this\.state\.(.+?)}/g,
        (attribute, initial) ->

          path = [raw_ctx, attribute].join('.')
          HandlebarsLookups.add(path)
          "{#{Replacer.addState(path)}}"

      result = Replacer.replace result, /this\.action\,\ \'(.+?)\'/g,
        (attribute, initial) ->
          path = [raw_ctx, attribute].join('.')
          "#{Replacer.addAction(path)}"

      result

  return {
    init: init
  }
)()

module.exports = HandlebarsHelpers
