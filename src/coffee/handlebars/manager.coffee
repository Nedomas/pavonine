HandlebarsManager = (->
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  init = ->
    @patchCompiler()
    HandlebarsHelpers.init()

  patchCompiler = ->
    Handlebars.JavaScriptCompiler::nameLookup = (parent, name, type) ->
      _.each @environment.opcodes, (opcode) ->
        return unless opcode.opcode == 'lookupOnContext'

        # ``name`` is a receiver (e.g. current_user)
        return if _.include(_.keys(Handlebars.helpers), name)
        HandlebarsLookups.addOnContext(name)

        # ``lookup`` is a full lookup
        lookup = opcode.args[0].join('.')
        HandlebarsLookups.addOnContext(lookup)

      if Handlebars.JavaScriptCompiler.isValidJavaScriptVariableName(name)
        "#{parent}.#{name}"
      else
        parent + "['" + name + "']"

  return {
    init: init
    patchCompiler: patchCompiler
  }
)()

module.exports = HandlebarsManager
