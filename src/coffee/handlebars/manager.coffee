HandlebarsManager = (->
  _ = require 'lodash'
  Handlebars = require 'handlebars'
  HandlebarsLookups = require './lookups'
  HandlebarsHelpers = require './helpers'

  patchCompiler = ->
    Handlebars.JavaScriptCompiler::nameLookup = (parent, name, type) ->
      _.each @environment.opcodes, (opcode) ->
        if opcode.opcode == 'lookupOnContext'
          lookup = opcode.args[0]
          HandlebarsLookups.add(lookup.join('.'))

      if Handlebars.JavaScriptCompiler.isValidJavaScriptVariableName(name)
        "#{parent}.#{name}"
      else
        parent + "['" + name + "']"

  init = ->
    patchCompiler()
    HandlebarsHelpers.init()

  return {
    init: init
  }
)()

module.exports = HandlebarsManager
