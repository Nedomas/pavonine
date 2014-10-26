Replacer = module.exports = (->
  React = require('react')
  HTMLtoJSX = require('../vendor/htmltojsx.min')
  react_tools = require('react-tools')
  Memory = require './memory'
  ReactMixin = require './react_mixin'
  _ = require 'lodash'
  $ = require 'jquery'

  toReactCode = (jsx_code) ->
    jsx_code = removeExtraQuotes(jsx_code)
    jsx_code = capitalizeActionCase(jsx_code)
    jsx_code = replaceToBindings(jsx_code)
    jsx_code = replaceToActions(jsx_code)
    replaceToState(jsx_code)

  removeExtraQuotes = (jsx_code) ->
    jsx_code.replace(/"{/g, '{').replace(/}"/g, '}')

  capitalizeActionCase = (jsx_code) ->
    words = ['onChange', 'onClick']
    result = jsx_code

    _.each words, (word) ->
      result = result.replace word.toLowerCase(), word

    result

  replaceToActions = (jsx_code) ->
    # {create} => {this.create}
    actions = ['create', 'update', 'destroy', 'previous', 'next']

    replace jsx_code, /{([a-z]*)}/gi, (attribute) ->
      return "{#{attribute}}" unless _.include(actions, attribute)
      "{this.#{attribute}}"

  replaceToState = (jsx_code) ->
    replace jsx_code, /{([a-zA-Z]*)}/gi, (attribute) ->
      "{this.state.#{attribute}}"

  replaceToBindings = (jsx_code) ->
    # value={email}
    # =>
    # value={email} onChange={_.partial(this.onChange, 'email')}
    replace jsx_code, /value={(.+?)}/gi, (attribute) ->
      "value={#{attribute}} onChange={_.partial(this.onChange, '#{attribute}')}"

  replace = (code, from, to) ->
    result = code

    loop
      matched = from.exec(result)

      if matched
        attribute = matched[1]
        length = matched[0].length
        result = result.splice(matched.index, length, to(attribute))
      else
        break

    result

  return {
    toReactCode: toReactCode
  }
)()
