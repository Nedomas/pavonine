class ParamsUtils
  _ = require 'lodash'

  @raw: (ctx, ctx_id) ->
    return unless ctx or ctx_id

    result = @wrap(ctx, ctx_id)

    if match = result.match(/\((.*?)\)/)
      [result, options...] = match[1].split(', ')
    else if _.isString(ctx)
      if ctx.match(/^{(.*)}$/)
        result = ctx_id
      else
        result = "'#{result}'"
    else
      result = ctx_id

    result.replace('this.state.', '')

  @wrap: (ctx, ctx_id) ->
    result = ctx || ctx_id
    result = result.toString()

    if div_match = result.match(/<div>\n{(.*?)}\n<\/div>/)
      result = div_match[1]
    else if braces_match = result.match(/^{(.*?)}$/)
      result = braces_match[1]

    result

module.exports = ParamsUtils
