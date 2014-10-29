UI = module.exports = (->
  React = require 'react'
  Converter = require './converter'
  _ = require 'lodash'
  $ = require 'jquery'

  hideAll = ->
    removePreviousSteps()
    _.each elements(), (el) ->
      step = el.attr('step') or 1
      hide(step)

  hide = (step) ->
    element(step).hide()

  removePreviousSteps = ->
    _.each components(), (component) ->
      component.remove()

  render = (step) ->
    loading(true)
    hideAll()
    component = insertComponent(step)
    $(component.getDOMNode()).show()
    loading(false)

  loading = (show) ->
    $('[loading]').toggle(show)

  insertComponent = (i) ->
    return if _.isEmpty(element(i))

    rendered_component = renderComponent(i)
    Router = require './router'
    Router.setCurrent(i)
    rendered_component

  component = (i) ->
    Converter.htmlToReactComponent(klassName(i), outerElementHtml(i))()

  renderComponent = (i) ->
    container = insertContainter(i)
    React.renderComponent(component(i), container)

  insertContainter = (step) ->
    element(step).before("<div class='#{klassName(step)}'>")
    $(".#{klassName(step)}")[0]

  klassName = (step) ->
    "cornflake#{step}"

  outerElement = (i) ->
    $(outerHtml(element(i)))

  outerElementHtml = (i) ->
    outerHtml(element(i))

  element = (i) ->
    idx()[i]

  outerHtml = (element) ->
    $('<div>').append(element.clone()).html()

  idx = ->
    _.inject(elements(), (result, element) ->
      step = $(element).attr('step') or 1
      result[step] = $(element)
      result
    , {})

  elements = ->
    _.map $('*[model], *[step]'), (el) -> $(el)

  components = ->
    _.map $("[class^='cornflake']"), (el) -> $(el)

  return {
    render: render
    element: element
  }
)()
