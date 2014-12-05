class VanillaHelpers
  _ = require 'lodash'

  # {{reverse users}} -> this.state.users.reverse()
  @register: ->
    HandlebarsHelpers = require './helpers'
    helpers = ['reverse']

    _.each helpers, (method) ->
      HandlebarsHelpers.register method, (raw_ctx, wrapped_ctx, args, opts) ->
        "#{wrapped_ctx}.#{method}(#{args.join(', ')})"

module.exports = VanillaHelpers
