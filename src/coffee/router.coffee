Router = (->
  UI = require './ui'
  Data = require './data'

  step = 1
  return_to = 1

  change = (_step, dont_clean) ->
    step = _step

    ui = new UI(step)
    ui.compile()

    Data.getMissing().then(->
      ui.render()
    ).fail( (resp) ->
      if resp == 'login'
        return_to = step
        change('login')
      else
        throw new Error "Server responded with error #{resp}"
    )

  previous = (current_data) ->
    change(step - 1)

  next = (current_data) ->
    change(step + 1)

  goOn = ->
    change(return_to)

  return {
    change: change
    previous: previous
    next: next
    goOn: goOn
  }
)()

module.exports = Router
