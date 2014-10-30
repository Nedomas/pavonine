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
    previous: previous
    next: next
  }
)()
