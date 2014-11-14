UI = (->
  React = require 'react'
  _ = require 'lodash'
  $ = require 'jquery'
  Converter = require './converter'

  removeAll = ->
    _.each elements(), (el) ->
      el.html('')

    $(loginContainer()).html('')

  render = (step) ->
    loading(true)
    removeAll()
    content = Compiler.stepContent(step)
    componentF = component(klassName(step), content)
    rendered_component = renderComponent(componentF, stepContainer(step))
    $(rendered_component.getDOMNode()).show()
    loading(false)

  login = ->
    loading(true)
    removeAll()
    content = Compiler.loginContent()
    componentF = component(klassName('login'), content)
    rendered_component = renderComponent(componentF, loginContainer())
    $(rendered_component.getDOMNode()).show()
    loading(false)

  loading = (show) ->
    $('*[loading]').toggle(show)

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

  loadingElement = ->
    $('*[loading]')

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
