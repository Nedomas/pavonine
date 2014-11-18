class UI
  React = require 'react'
  _ = require 'lodash'
  $ = require 'jquery'
  Converter = require './converter'
  Data = require './data'

  constructor: (step) ->
    @step = step

  compile: ->
    @react_component = @component()

  klassName: ->
    "cornflake_#{@step}"

  component: ->
    Converter.htmlToReactComponent(@klassName(), @content())()

  content: ->
    if @step == 'login'
      Compiler.loginContent()
    else
      Compiler.stepContent(@step)

  render: ->
    @loading(true)
    @removeAll()
    $(@renderComponent().getDOMNode()).show()
    @loading(false)

  renderComponent: ->
    React.renderComponent(@react_component, @container())

  removeAll: ->
    _.each @elements(), (el) ->
      el.html('')

    $(@loginContainer()).html('')

  loading: (show) ->
    @loadingElement().toggle(show)

  container: ->
    if @step == 'login'
      @loginContainer()
    else
      @idx()[@step][0]

  loginContainer: ->
    $('*[login]')[0]

  loadingElement: ->
    $('*[loading]')

  idx: ->
    _.inject(@elements(), (result, element) ->
      step = $(element).attr('step') or 1
      result[step] = $(element)
      result
    , {})

  elements: ->
    _.map $('*[step]'), (el) -> $(el)

module.exports = UI
