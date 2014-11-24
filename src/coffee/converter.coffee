Converter = (->
  react_tools = require 'react-tools'
  HTMLtoJSX = require '../vendor/htmltojsx.min'
  Replacer = require './replacer'
  Handlebars = require 'handlebars'
  HandlebarsLookups = require './handlebars/lookups'
  HandlebarsMock = require './handlebars/mock'

  htmlToReactComponent = (klass_name, element) ->
    xhtml = toXHTML(element)
    jsx = toJSX(klass_name, xhtml)
    toComponent(klass_name, jsx)

  toComponent = (klass_name, jsx) ->
    component_code = react_tools.transform(jsx)
    ReactMixin = require './react_mixin'
    React = require 'react'
    _ = require 'lodash'
    moment = require 'moment'
    eval(component_code)
    eval(klass_name)

  toJSX = (klass_name, html) ->
    HandlebarsLookups.clean()
    template = Handlebars.compile(html, trackIds: true)
    t = template() # gather data
    HandlebarsMock.scanDefaultValues(t)

    mocked = template(HandlebarsMock.get()).toString()
    wrapped = wrapInJSX(klass_name, mocked)
    react_code = Replacer.toReactCode(wrapped)

  wrapInJSX = (klass_name, html) ->
    converter = new HTMLtoJSX
      createClass: true
      outputClassName: klass_name

    jsx_code = "/** @jsx React.DOM */\n" + converter.convert(html)
    render_index = jsx_code.match('render').index
    jsx_code = Replacer.splice(jsx_code, render_index, 0,
      'mixins: [ReactMixin],\n  ')

  INNER_BODY_REGEX = /<body>([\s\S]*?.*[\s\S*?])<\/body>/

  toXHTML = (input) ->
    without_spaces = input.replace('\n', '').replace(/\s{2,}/g, '')
    doc = new DOMParser().parseFromString(without_spaces, 'text/html')
    result = new XMLSerializer().serializeToString(doc)
    INNER_BODY_REGEX.exec(result)
    RegExp.$1

  return {
    htmlToReactComponent: htmlToReactComponent
  }
)()

module.exports = Converter
