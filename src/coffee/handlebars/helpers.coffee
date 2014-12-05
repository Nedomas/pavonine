class HandlebarsHelpers
  Handlebars = require 'handlebars'
  LodashHelpers = require './lodash_helpers'
  BaseHelpers = require './base_helpers'
  MomentHelpers = require './moment_helpers'
  VanillaHelpers = require './vanilla_helpers'
  SafeWrapper = require './safe_wrapper'

  @CONSTANTS: ->
    actions: ['create', 'update', 'destroy', 'previous', 'next', 'facebook']

  @constant: (name) ->
    @CONSTANTS()[name]

  @init: ->
    # register sortBy, first, last, max, etc.
    LodashHelpers.register()
    # register each, if, with.
    BaseHelpers.register()
    # register moment helper
    MomentHelpers.register()
    # register some vanilla.js helpers (reverse, etc.)
    VanillaHelpers.register()

  @register: (method, fn_from_helper) ->
    Handlebars.registerHelper method, =>
      @registerWithParsedParams(fn_from_helper, arguments)

  @registerWithParsedParams: (fn_from_helper, args) ->
    HandlebarsParams = require './params'
    params = new HandlebarsParams(args)

    result = fn_from_helper(params.ctx(), params.wrappedCtx(),
      params.args(), params.opts())
    SafeWrapper.string(result)

module.exports = HandlebarsHelpers
