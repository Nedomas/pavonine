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

  change = (_step, dont_clean) ->
    Memory.clean() unless dont_clean
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
    change(step, true)

  getMissing = ->
    Persistance = require './persistance'
    variable = _.first(Data.missingVariables())

    if variable == 'current_user'
      if attributes = Memory.getForever('current_user')
        for_request = _.pick(attributes, 'id', 'access_token', 'model')
        Persistance.communicate('update', for_request).then (current_user) ->
          Memory.setForever(current_user.attributes)
          goOn()
      else
        login()
    else
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
