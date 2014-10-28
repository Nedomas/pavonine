Replacer = module.exports = (->
  _ = require 'lodash'
  actions = ['create', 'update', 'destroy', 'previous', 'next']

  toReactCode = (jsx_code) ->
    jsx_code = removeExtraQuotes(jsx_code)
    jsx_code = capitalizeActionCase(jsx_code)
    jsx_code = replaceToBindings(jsx_code)
    jsx_code = replaceToActions(jsx_code)
    jsx_code = replaceToState(jsx_code)
    console.log(jsx_code)
    jsx_code

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
    replace jsx_code, /{([a-z]*)}/gi, (attribute) ->
      return "{#{attribute}}" unless matchAction(attribute)
      "{this.#{attribute}}"

  replaceToState = (jsx_code) ->
    replace jsx_code, /{([a-zA-Z.]*)}/gi, (attribute) ->
      initial = "{#{attribute}}"
      return initial if attribute.match(/^this./)
      return initial if matchAction(attribute)

      "{this.state.#{attribute}}"

  matchAction = (attribute) ->
    _.any actions, (action) ->
      attribute.match(new RegExp("#{action}$"))

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
