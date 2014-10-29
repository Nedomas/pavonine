Router = module.exports = (->
  Memory = require './memory'
  UI = require './ui'

  step = 1

  setCurrent = (_step) ->
    step = _step

  current = ->
    step

  change = (_step) ->
    step = _step
    UI.render(step)

  previous = (current_data) ->
    debugger
    Memory.set(current_data)
    change(step - 1)

  next = (current_data) ->
    Memory.set(current_data)
    change(step + 1)

  return {
    current: current
    setCurrent: setCurrent
    change: change
    previous: previous
    next: next
  }
)()
