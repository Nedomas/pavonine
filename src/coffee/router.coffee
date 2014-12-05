# gets data from the backend and renders requested step
module.exports =
class Router
  UI = require './ui'
  MissingData = require './missing_data'

  step = 1
  return_to = 1

  @change: (_step) ->
    step = _step

    ui = new UI(step)
    ui.compile()

    MissingData.get().then(->
      ui.render()
    ).fail( (resp) =>
      if resp == 'login'
        return_to = step
        @change('login')
      else
        throw new Error "Server responded with error #{resp}"
    )

  @previous: ->
    @change(step - 1)

  @next: ->
    @change(step + 1)

  @goOn: ->
    @change(return_to)
