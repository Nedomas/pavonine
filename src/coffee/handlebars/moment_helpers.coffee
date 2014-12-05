class MomentHelpers
  _ = require 'lodash'

  @register: ->
    HandlebarsHelpers = require './helpers'
    HandlebarsHelpers.register 'moment', (raw_ctx, wrapped_ctx, args, opts) ->
      methods = []

      _.each args[0], (param, method) ->
        methods.push("#{method}('#{param}')")

      "moment(#{wrapped_ctx}).#{methods.join('.')}"

module.exports = MomentHelpers
