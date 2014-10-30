Data = (->
  _ = require 'lodash'
  Handlebarser = require './handlebarser'
  Memory = require './memory'

  missingVariables = ->
    result = []
    result.push('current_user') if used('current_user') and !loggedIn()
    result

  missing = ->
    !_.isEmpty(missingVariables())

  used = (key) ->
    !!Handlebarser.mock()[key]

  loggedIn = ->
    !_.isEmpty(Memory.get('current_user'))

  return {
    missing: missing
    missingVariables: missingVariables
  }
)()

module.exports = Data
