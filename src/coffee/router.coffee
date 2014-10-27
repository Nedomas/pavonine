Router = module.exports = (->
  Memory = require './memory'
  UI = require './ui'

  step = 1

  setCurrent = (_step) ->
    step = _step

  current = ->
    step

  change = (step) ->
    UI.render(step)

  previous = (results) ->
    Memory.set(step, results)
    change(step - 1)

  next = (results) ->
    Memory.set(step, results)
    change(step + 1)

  return {
    current: current
    setCurrent: setCurrent
    change: change
    previous: previous
    next: next
  }
)()
