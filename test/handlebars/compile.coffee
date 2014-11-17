module.exports = (html) ->
  Handlebars = require 'handlebars'
  result = Handlebars.compile(html, trackIds: true)()
  result?.string || result
