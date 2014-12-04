class Converter
  react_tools = require 'react-tools'
  HTMLtoJSX = require '../vendor/htmltojsx.min'
  Replacer = require './replacer'
  Handlebars = require 'handlebars'
  HandlebarsLookups = require './handlebars/lookups'
  HandlebarsMock = require './handlebars/mock'

  INNER_BODY_REGEX = /<div>([\s\S]*?.*[\s\S*?])<\/div>/

  constructor: (klass_name, element) ->
    @klass_name = klass_name
    @element = element

  componentCode: ->
    react_tools.transform(@reactCode())

  component: ->
    @evalWithDependencies(@componentCode(), @klass_name)()

  evalWithDependencies: (code, additional = '') ->
    ReactMixin = require './react_mixin'
    React = require 'react'
    _ = require 'lodash'
    moment = require 'moment'
    result = eval(code)
    result = eval(additional) if additional

    result

  mocked: ->
    HandlebarsLookups.clean()
    template = Handlebars.compile(@xhtml(), trackIds: true)
    t = template() # gather data
    HandlebarsMock.scanDefaultValues(t)

    template(HandlebarsMock.get()).toString()

  xhtml: ->
    without_spaces = @element.replace('\n', '').replace(/\s{2,}/g, '')
    doc = new DOMParser().parseFromString("<div>#{without_spaces}</div>",
      'text/html')
    result = new XMLSerializer().serializeToString(doc)

    @extractBody(result)

  jsx: ->
    converter = new HTMLtoJSX
      createClass: true
      outputClassName: @klass_name

    converter.convert(@mocked())

  reactCode: ->
    jsx_code = "/** @jsx React.DOM */\n" + @jsx()
    render_index = jsx_code.match('render').index
    jsx_code = Replacer.splice(jsx_code, render_index, 0,
      'mixins: [ReactMixin],\n  ')
    Replacer.toReactCode(jsx_code)

  extractBody: (input) ->
    INNER_BODY_REGEX.exec(input)
    RegExp.$1

module.exports = Converter
