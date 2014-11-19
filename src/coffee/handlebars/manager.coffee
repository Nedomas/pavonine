class HandlebarsManager
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  @patchCompiler: ->
    Handlebars.JavaScriptCompiler::nameLookup = (parent, name, type) ->
      _.each @environment.opcodes, (opcode) ->
        if opcode.opcode == 'lookupOnContext'
          lookup = opcode.args[0].join('.')

          if lookup == 'facebook.login'
            HandlebarsLookups.addOnContext(lookup)
          else
            HandlebarsLookups.addOnContext(name)

      if Handlebars.JavaScriptCompiler.isValidJavaScriptVariableName(name)
        "#{parent}.#{name}"
      else
        parent + "['" + name + "']"

  @init: ->
    @patchCompiler()
    HandlebarsHelpers.init()

module.exports = HandlebarsManager
