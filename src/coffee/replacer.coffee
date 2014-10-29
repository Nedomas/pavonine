Replacer = module.exports = (->
  Handlebars = require 'handlebars'
  _ = require 'lodash'
  actions = ['create', 'update', 'destroy', 'previous', 'next']

  toReactCode = (jsx_code) ->
    jsx_code = removeExtraQuotes(jsx_code)
    jsx_code = capitalizeActionCase(jsx_code)
    jsx_code = replaceToBindings(jsx_code)

  removeExtraQuotes = (jsx_code) ->
    jsx_code.replace(/"{/g, '{').replace(/}"/g, '}')

  capitalizeActionCase = (jsx_code) ->
    words = ['onChange', 'onClick']
    result = jsx_code

    _.each words, (word) ->
      result = replace(result, word.toLowerCase(), -> word)

    result

  replaceToBindings = (jsx_code) ->
    # value={email}
    # =>
    # value={email} onChange={_.partial(this.onChange, 'subscriber.email')}
    replace jsx_code, /value={(.+?)}/gi, (attribute) ->
      "value={#{attribute}} onChange={_.partial(this.onChange, '#{attribute}')}"

  replace = (code, from, to) ->
    result = code
    regexp = new RegExp(from)

    loop
      matched = regexp.exec(result)

      if matched
        full_match = matched[0]
        attribute = matched[1]
        length = full_match.length
        result = result.splice(matched.index, length, to(attribute, full_match))
      else
        break

    result

  toState = (initial) ->
    "this.state.#{initial.join('.')}"

  toAction = (initial) ->
    "_.partial(this.action, '#{initial.join('.')}')"

  toAttribute = (initial) ->
    initial.replace('this.state.', '')

  return {
    toReactCode: toReactCode
    replace: replace
    toState: toState
    toAction: toAction
    toAttribute: toAttribute
  }
)()
