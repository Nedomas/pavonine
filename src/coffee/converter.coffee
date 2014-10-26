Converter = module.exports = (->
  React = require('react')
  HTMLtoJSX = require('../vendor/htmltojsx.min')
  react_tools = require('react-tools')
  Memory = require './memory'
  ReactMixin = require './react_mixin'
  Replacer = require './replacer'
  _ = require 'lodash'
  $ = require 'jquery'

  htmlToReactComponent = (klass_name, element) ->
    xhtml = toXHTML(element)
    jsx = toJSX(klass_name, xhtml)
    toComponent(klass_name, jsx)

  toComponent = (klass_name, jsx) ->
    component_code = react_tools.transform(jsx)
    eval(component_code)
    eval(klass_name)

  toJSX = (klass_name, html) ->
    jsx_code = wrapInJSX(klass_name, html)
    Replacer.toReactCode(jsx_code)

  wrapInJSX = (klass_name, html) ->
    converter = new HTMLtoJSX
      createClass: true
      outputClassName: klass_name

    jsx_code = "/** @jsx React.DOM */\n" + converter.convert(html)
    render_index = jsx_code.match('render').index
    jsx_code = jsx_code.splice(render_index, 0,
      'mixins: [ReactMixin],\n  ')

    # result =
    #   l('/** @jsx React.DOM */') +
    #   l("var #{klass_name} = React.createClass({") +
    #   l('  mixins: [CoreMixin],') +
    #   l('  render: function() {') +
    #   l('    return (') +
    #   l("      #{html}") +
    #   l('    );') +
    #   l('  }') +
    #   l('});')

  l = (code) ->
    "#{code}\n"

  toXHTML = (input) ->
    without_spaces = input.replace('\n', '').replace(/\s{2,}/g, '')
    doc = new DOMParser().parseFromString(without_spaces, 'text/html')
    result = new XMLSerializer().serializeToString(doc)
    /<body>(.*)<\/body>/im.exec(result)
    RegExp.$1

  return {
    htmlToReactComponent: htmlToReactComponent
  }
)()