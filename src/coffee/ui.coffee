class UI
  $ = require 'jquery'
  _ = require 'lodash'
  React = require 'react'
  Converter = require './converter'

  constructor: (step) ->
    @step = step

  compile: ->
    @react_component = @component()

  klassName: ->
    "pavonine_#{@step}"

  component: ->
    converter = new Converter(@klassName(), @content())
    converter.component()

  content: ->
    window.PAVONINE_STEPS[@step] or throw new Error("No step '#{@step}'")

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
