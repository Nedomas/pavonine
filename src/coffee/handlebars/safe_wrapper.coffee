class SafeWrapper
  Handlebars = require 'handlebars'

  HTML_REGEX = /^<([\s\S]*?.+?[\s\S]*?)>$/

  @string: (result) ->
    if result.match(HTML_REGEX)
      code = @div(result)
    else
      code = "\n<div>\n" +
      "{#{result}}\n" +
      "</div>"

    new Handlebars.SafeString code

  # there cannot be unwrapped DOM elements (like [<div></div><p></p>]) given
  # to React render method. You got to wrap them with one parent DOM
  @div: (content) ->
    return unless content

    "<div>" +
    content +
    "</div>"

module.exports = SafeWrapper
