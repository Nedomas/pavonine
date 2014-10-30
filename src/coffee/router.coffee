Router = (->
  Memory = require './memory'
  UI = require './ui'
  Data = require './data'
  _ = require 'lodash'
  Persistance = require './persistance'

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
    variable = _.first(Data.missingVariables())

    if variable == 'current_user'
      login()
    else
      Persistance = require './persistance'
      attributes =
        model: singularize(variable)

      Persistance.communicate('where', attributes).then (records) ->
        goOn()

  singularize = (string) ->
    string.replace(/s$/, '')

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

module.exports = Router
