# HTMLtoJSX = require('htmltojsx')
# _ = require('lodash')
# Godfather = require 'godfather'

Cornflake = (->
  step_results = {}

  init = ->
    console.log('Here and now')
    Godfather.API_URL = 'http://10.30.0.1:3000'
    debugger
    # converter = new HTMLtoJSX
    #   createClass: true
    #   outputClassName: 'AwesomeComponent'
    # debugger

    state(1)

  state = (i) ->
    interpolate(i)
    CornflakeSteps.changeStep(i)

  interpolate = (i) ->
    state_part = CornflakeSteps.element(i)
    state_html = $('<div>').append(state_part.clone()).html()
    data = step_results[i - 1]

    result = state_html

    _.each keywords(state_html), (keyword) ->
      value = data[keyword] or throw "No value for #{keyword} in #{data}"
      result = result.replace('#{' + keyword + '}', value)

    state_part.replaceWith(result)

  keywords = (text) ->
    all = text.match(/#{[a-z0-9]+}/)
    _.map all, (keyword) ->
      keyword.replace('#{', '').replace('}', '')

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
      state(step_number + 1)

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
    element: element
  }
)()

window.onload = ->
  Cornflake.init()
