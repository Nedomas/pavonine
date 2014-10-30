UI = (->
  React = require 'react'
  _ = require 'lodash'
  $ = require 'jquery'
  Converter = require './converter'

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
    # hideAll()
    content = Compiler.stepContent(step)
    componentF = component(klassName(step), content)
    rendered_component = renderComponent(componentF, stepContainer(step))
    $(rendered_component.getDOMNode()).show()
    # debugger
    loading(false)

  login = ->
    loading(true)
    content = Compiler.loginContent()
    componentF = component(klassName('login'), content)
    rendered_component = renderComponent(componentF, loginContainer())
    $(rendered_component.getDOMNode()).show()
    # hideAll()
    # component = insertComponent(step)
    # $(component.getDOMNode()).show()
    loading(false)

  loading = (show) ->
    $('[loading]').toggle(show)

  component = (klass_name, content) ->
    Converter.htmlToReactComponent(klass_name, content)()

  renderComponent = (component, container) ->
    React.renderComponent(component, container)

  klassName = (suffix) ->
    "cornflake_#{suffix}"

  stepContainer = (i) ->
    idx()[i][0]

  loginContainer = ->
    $('*[login]')[0]

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
    login: login
  }
)()

module.exports = UI
