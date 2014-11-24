VanillaHelpers = (->
  _ = require 'lodash'

  register = ->
    HandlebarsHelpers = require './helpers'
    helpers = ['reverse']

    _.each helpers, (method) ->
      HandlebarsHelpers.register method, (raw_ctx, wrapped_ctx, args, opts) ->
        "#{wrapped_ctx}.#{method}(#{args.join(', ')})"

  return {
    register: register
  }
)()

module.exports = VanillaHelpers
