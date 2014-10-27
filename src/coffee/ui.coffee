UI = module.exports = (->
  React = require('react')
  Memory = require './memory'
  Converter = require './converter'
  _ = require 'lodash'
  $ = require 'jquery'

  current_state = 1

  currentState = ->
    current_state

  previousState = (results) ->
    Memory.set(current_state, results)
    state(current_state - 1)

  nextState = (results) ->
    Memory.set(current_state, results)
    state(current_state + 1)

  state = (i) ->
    return if _.isEmpty(element(i))

    current_state = i
    hideAllBut(i)
    klass_name = "cornflake#{random()}"
    component = Converter.htmlToReactComponent(klass_name,
      outerHtml(element(i)))
    element(i).before("<div id='#{klass_name}'>")
    element(i).hide()
    React.renderComponent(component(),
      document.getElementById(klass_name))

  random = ->
    min = 1
    max = 10000
    Math.floor(Math.random() * (max - min + 1)) + min

  hideAllBut = (dont_hide_i) ->
    _.each $('*[data-model], *[data-step]'), (element) ->
      jelement = $(element)
      step = jelement.data('step') or 1

      if parseInt(step) == dont_hide_i
        jelement.show()
      else
        if jelement.data('reactid')
          jelement.remove()
        else
          jelement.hide()

  element = (i) ->
    idx()[i]

  outerHtml = (element) ->
    $('<div>').append(element.clone()).html()

  idx = ->
    _.inject(elements(), (result, element) ->
      step = $(element).data('step') or 1
      result[step] = $(element)
      result
    , {})

  elements = ->
    $('*[data-model], *[data-step]')

  return {
    previousState: previousState
    nextState: nextState
    currentState: currentState
    state: state
    element: element
  }
)()
