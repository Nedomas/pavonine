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
      result = replace(result, word.toLowerCase(), -> word)

    result

  replaceToActions = (jsx_code) ->
    # {create} => {this.create}
    replace jsx_code, /{([a-z.]*)}/gi, (attribute, initial) ->
      return initial unless matchAction(attribute)

      if attribute.match(/\./)
        # {subscriber.create}
        # =>
        # {_.partial(this.relationshipAction, 'subscriber', 'create')}

        [model, action] = attribute.split('.')
        "{_.partial(this.relationshipAction, '#{model}', '#{action}')}"
      else
        "{this.#{attribute}}"

  replaceToState = (jsx_code) ->
    replace jsx_code, /{([a-zA-Z.]*)}/gi, (attribute, initial) ->
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
      if attribute.match(/\./)
        # {subscriber.create}
        # =>
        # {_.partial(this.relationshipAction, 'subscriber', 'create')}

        [model, attr] = attribute.split('.')
        "value={#{attribute}} onChange={_.partial(this.relationshipOnChange, '#{attribute}')}"
      else
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

  return {
    toReactCode: toReactCode
  }
)()
