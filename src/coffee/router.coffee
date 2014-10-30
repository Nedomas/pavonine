Router = module.exports = (->
  Memory = require './memory'
  UI = require './ui'
  Data = require './data'
  _ = require 'lodash'

  step = 1

  setCurrent = (_step) ->
    step = _step

  current = ->
    step

  change = (_step) ->
    step = _step

    try
      UI.render(step)
      setCurrent(step)
    catch e
      # console.log Data.missingVariables()
      # console.log Memory.get('current_user')

      if e.message == 'get_missing'
        getMissing()
      else
        throw e

  previous = (current_data) ->
    Memory.set(current_data)
    change(step - 1)

  next = (current_data) ->
    Memory.set(current_data)
    change(step + 1)

  goOn = ->
    change(step)

  getMissing = ->
    _.each Data.missingVariables(), (variable) ->
      if variable == 'current_user'
        login()

  login = ->
    UI.login()

  return {
    current: current
    change: change
    login: login
    goOn: goOn
    previous: previous
    next: next
  }
)()
