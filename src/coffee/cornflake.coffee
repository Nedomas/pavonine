Cornflake = (->
  step_results = {}

  init = ->
    console.log('Here and now')
    Godfather.API_URL = 'http://10.30.0.1:3000'
    CornflakeSteps.changeStep(1)

  bindStep = (model, attributes, action) ->
    $(action.element).click(_.partial(act, model, attributes, action))

  act = (model, attributes, action, e) ->
    e.preventDefault()

    connection = new Godfather("#{model}s")
    attribute_values = _.inject(attributes, (result, element, name) ->
      result[name] = element.val()
      result
    , {})

    connection[action.name](attribute_values).then (record) ->
      step_number = 1
      step_results[step_number] = record
      CornflakeSteps.changeStep(step_number + 1)

  return {
    init: init
    bindStep: bindStep
  }
)()

CornflakeSteps = (->
  changeStep = (i) ->
    hideAllBut(i)
    binding(i)

  binding = (i) ->
    model = element(i).data('model')
    attributeElements = element(i).find('*[data-attribute]')
    attributes = _.inject(attributeElements, (result, element) ->
      result[$(element).data('attribute')] = $(element)
      result
    , {})

    actionElement = element(i).find('*[data-action]').first()
    action = { element: actionElement, name: $(actionElement).data('action') }

    Cornflake.bindStep(model, attributes, action)

  hideAllBut = (dont_hide_i) ->
    _.each idx(), (element, i) ->
      if parseInt(i) == dont_hide_i
        element.show()
      else
        element.hide()

  element = (i) ->
    idx()[i]

  idx = ->
    _.inject(elements(), (result, element) ->
      step = $(element).data('step') or 1
      result[step] = $(element)
      result
    , {})

  elements = ->
    $('*[data-model], *[data-step]')

  return {
    changeStep: changeStep
  }
)()

window.onload = ->
  Cornflake.init()
