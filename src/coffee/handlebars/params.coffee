class HandlebarsParams
  _ = require 'lodash'
  Replacer = require '../replacer'
  HandlebarsMock = require './mock'
  ParamsUtils = require './params_utils'

  constructor: (args) ->
    @handlebars_mock = HandlebarsMock.get()

    # work on helpers with only first options object (moment.js etc.)
    if args.length == 1 and _.isPlainObject(args[0])
      args = [undefined].concat(args[0])

    # ``initial_ctx`` is a string: {{helper 'this_is_initial_ctx'}}
    # ``initial_ctx_id`` is a var: {{helper this_is_initial_ctx_id}}
    # ``initial_args`` is string args: {{helper 'test' 'first_arg'}}
    # ``initial_arg_ids`` is var args: {{helper 'test' first_arg}}
    # all are converted to string via ``ParamsUtils.raw``
    # ``initial_opts`` are the opts from Handlebars
    # they contain helper content and all meta {{#last user}}CONTENT{{/last}}

    [@initial_ctx, @initial_args..., @initial_opts] = args
    [@initial_ctx_id, @initial_arg_ids...] = @initial_opts.ids

  ctx: ->
    ParamsUtils.raw(@initial_ctx, @initial_ctx_id)

  wrappedCtx: ->
    return unless @initial_ctx or @initial_ctx_id

    result = ParamsUtils.wrap(@initial_ctx, @initial_ctx_id)

    # remove earlier states
    result = result.replace("this.state.#{@ctx()}", @ctx())

    result.replace(@ctx(), Replacer.addState(@ctx()))

  args: ->
    result = []

    _.each @initial_args, (arg, i) =>
      result[i] = ParamsUtils.raw(@initial_args[i], @initial_arg_ids[i])

    result.push(@initial_opts.hash) unless _.isEmpty(_.keys(@initial_opts.hash))
    result

  opts: ->
    result = {}
    result.method = @initial_opts.name

    if @initial_opts.fn
      result.fn = @initial_opts.fn(@handlebars_mock)

    if @initial_opts.inverse
      result.inverse = @initial_opts.inverse(@handlebars_mock)

    result

module.exports = HandlebarsParams
