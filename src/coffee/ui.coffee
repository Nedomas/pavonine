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
    container(step).hide()

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
    rendered_component = renderComponent(i)
    Router = require './router'
    Router.setCurrent(i)
    rendered_component

  component = (i) ->
    Converter.htmlToReactComponent(klassName(i), Compiler.stepContent(i))()

  renderComponent = (i) ->
    React.renderComponent(component(i), container(i))

  # insertContainter = (step) ->
  #   element(step).before("<div class='#{klassName(step)}'>")
  #   $(".#{klassName(step)}")[0]

  klassName = (step) ->
    "cornflake#{step}"

  container = (i) ->
    idx()[i]

  idx = ->
    _.inject(elements(), (result, element) ->
      step = $(element).attr('step') or 1
      result[step] = $(element)
      result
    , {})

  elements = ->
    _.map $('*[step]'), (el) -> $(el)

  components = ->
    _.map $("[class^='cornflake']"), (el) -> $(el)

  return {
    render: render
  }
)()
