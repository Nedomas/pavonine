class BaseHelpers
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'
  Replacer = require '../replacer'
  SafeWrapper = require './safe_wrapper'

  @register: ->
    @registerEach()
    @registerIf()
    @registerWith()

  @registerEach: ->
    HandlebarsHelpers = require './helpers'
    HandlebarsHelpers.register 'each', (raw_ctx, wrapped_ctx, args, opts) ->
      HandlebarsLookups.addCollection(raw_ctx)

      each_iteration = Replacer.replace opts.fn,
        /this\.state\.(.+?)/, (attribute, initial) ->
          "record.#{attribute}"

      records_exist = "_.map(#{wrapped_ctx}, function(record, i) {\n" +
      "return #{each_iteration}\n" +
      '})'

      if opts.inverse
        "#{wrapped_ctx}.length ? (#{records_exist}) : (#{opts.inverse})"
      else
        records_exist

  @registerIf: ->
    HandlebarsHelpers.register 'if', (raw_ctx, wrapped_ctx, args, opts) ->
      "#{wrapped_ctx} ? #{SafeWrapper.div(opts.fn || null)} : #{SafeWrapper.div(opts.inverse || null)}"

  @registerWith: ->
    HandlebarsHelpers.register 'with', (raw_ctx, wrapped_ctx, args, opts) ->
      result = Replacer.replace opts.fn, /{this\.state\.(.+?)}/g,
        (attribute, initial) ->

          path = [raw_ctx, attribute].join('.')
          HandlebarsLookups.add(path)
          "{#{Replacer.addState(path)}}"

      ACTION_PARTIAL_REGEX = /_\.partial\(this\.action\,\ &#x27;(.+?)&#x27;\)/g
      result = Replacer.replace result, ACTION_PARTIAL_REGEX,
        (attribute, initial) ->
          path = [raw_ctx, attribute].join('.')
          "#{Replacer.addAction(path)}"

      SafeWrapper.div(result)

module.exports = BaseHelpers
