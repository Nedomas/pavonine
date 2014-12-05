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
    # register some regular javascript helpers (reverse, etc.)
    VanillaHelpers.register()

  @register: (method, final_fn) ->
    Handlebars.registerHelper method, =>
      @innerRegister(final_fn, arguments)

  @innerRegister: (final_fn, args) ->
    HandlebarsParams = require './params'
    params = new HandlebarsParams(args)

    final_helper = final_fn(params.rawCtx(), params.wrappedCtx(),
      params.args(), params.opts())
    SafeWrapper.string(final_helper)

module.exports = HandlebarsHelpers
