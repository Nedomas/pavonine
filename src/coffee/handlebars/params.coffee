class HandlebarsParams
  _ = require 'lodash'
  Replacer = require '../replacer'
  HandlebarsMock = require './mock'

  constructor: (args) ->
    @handlebars_mock = HandlebarsMock.get()

    # work on helpers with first object (moment.js etc.)
    if args.length == 1 and _.isPlainObject(args[0])
      args = [undefined].concat(args[0])

    [@initial_ctx, @initial_args..., @initial_opts] = args
    [@initial_ctx_id, @initial_arg_ids...] = @initial_opts.ids

  opts: ->
    result = {}
    result.method = @initial_opts.name

    if @initial_opts.fn
      result.fn = @initial_opts.fn(@handlebars_mock)

    if @initial_opts.inverse
      result.inverse = @initial_opts.inverse(@handlebars_mock)

    result

  args: ->
    result = []

    _.each @initial_args, (arg, i) =>
      result[i] = @getRaw(@initial_args[i], @initial_arg_ids[i])

    result.push(@initial_opts.hash) unless _.isEmpty(_.keys(@initial_opts.hash))
    result

  rawCtx: ->
    return unless @initial_ctx or @initial_ctx_id

    @getRaw(@initial_ctx, @initial_ctx_id)

  getRaw: (ctx, ctx_id) ->
    result = @getWrapped(ctx, ctx_id)

    if match = result.match(/\((.*?)\)/)
      [result, options...] = match[1].split(', ')
    else if _.isString(ctx)
      if ctx.match(/^{(.*)}$/)
        result = ctx_id
      else
        result = "'#{result}'"
    else
      result = ctx_id

    result.replace('this.state.', '')

  wrappedCtx: ->
    return unless @initial_ctx or @initial_ctx_id

    result = @wrapped()

    # remove earlier states
    result = result.replace("this.state.#{@rawCtx()}", @rawCtx())

    result.replace(@rawCtx(), Replacer.addState(@rawCtx()))

  wrapped: ->
    @getWrapped(@initial_ctx, @initial_ctx_id)

  getWrapped: (ctx, ctx_id) ->
    result = ctx || ctx_id
    result = result.toString()

    if div_match = result.match(/<div>\n{(.*?)}\n<\/div>/)
      result = div_match[1]
    else if braces_match = result.match(/^{(.*?)}$/)
      result = braces_match[1]

    result

module.exports = HandlebarsParams
