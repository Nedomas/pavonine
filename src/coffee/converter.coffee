Converter = (->
  react_tools = require 'react-tools'
  HTMLtoJSX = require '../vendor/htmltojsx.min'
  Replacer = require './replacer'
  Handlebars = require 'handlebars'
  Handlebarser = require './handlebarser'
  Data = require './data'

  htmlToReactComponent = (klass_name, element) ->
    xhtml = toXHTML(element)
    jsx = toJSX(klass_name, xhtml)
    toComponent(klass_name, jsx)

  toComponent = (klass_name, jsx) ->
    component_code = react_tools.transform(jsx)
    ReactMixin = require './react_mixin'
    React = require 'react'
    _ = require 'lodash'
    eval(component_code)
    console.log(component_code)
    eval(klass_name)

  toJSX = (klass_name, html) ->
    Handlebarser.clean()
    template = Handlebars.compile(html)
    template() # gather data

    throw new Error('get_missing') if Data.missing()

    mocked = template(Handlebarser.mock())
    wrapped = wrapInJSX(klass_name, mocked)
    react_code = Replacer.toReactCode(wrapped)
    console.log(react_code)
    react_code

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
#
#   l = (code) ->
#     "#{code}\n"

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
