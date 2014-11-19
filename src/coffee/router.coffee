Router = (->
  Memory = require './memory'
  UI = require './ui'
  Data = require './data'

  step = 1

  setCurrent = (_step) ->
    step = _step

  current = ->
    step

  change = (_step, dont_clean) ->
    Memory.clean() unless dont_clean
    step = _step

    ui = new UI(step)
    ui.compile()

    Data.getMissing().then(->
      ui.render()
      setCurrent(step)
    ).fail( (resp) ->
      if resp == 'login'
        change('login')
      else
        throw new Error "Server responded with error #{resp}"
    )

  previous = (current_data) ->
    change(step - 1)

  next = (current_data) ->
    change(step + 1)

  goOn = ->
    change(step, true)

  return {
    current: current
    change: change
    previous: previous
    next: next
    goOn: goOn
  }
)()

module.exports = Router
