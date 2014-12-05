class LodashHelpers
  _ = require 'lodash'

  @register: ->
    HandlebarsHelpers = require './helpers'
    # register all helpers from lodash library
    # {{min users 'age'}} -> _.min(this.state.users, 'age')
    helpers = _.without(_.keys(_), HandlebarsHelpers.constant('actions')...)

    _.each helpers, (method) ->
      HandlebarsHelpers.register method, (raw_ctx, wrapped_ctx, args, opts) ->
        if opts.fn
          if _.isEmpty(args)
            opts.fn.replace('this.state', "_.#{method}(#{wrapped_ctx})")
          else
            opts.fn.replace('this.state',
              "_.#{method}(#{wrapped_ctx}, #{args.join(', ')})")
        else
          fn_args = [wrapped_ctx, args...]
          "_.#{method}(#{fn_args.join(', ')})"

module.exports = LodashHelpers
