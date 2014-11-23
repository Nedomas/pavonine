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

        return if _.include(_.keys(Handlebars.helpers), name)
        HandlebarsLookups.addOnContext(name)

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
