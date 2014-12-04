global.compile = (html) ->
  Handlebars = require 'handlebars'
  result = Handlebars.compile(html, trackIds: true)()
  result?.string || result

global.mockDOM = (body, fn) ->
  jsdom = require('jsdom')

  jsdom.env(
    html: "<html><body>#{body}</body></html>"
    scripts: ['../bower_components/jquery/dist/jquery.min.js']
    done: (err, window) ->
      if err
        console.log(err)

      global.window = window
      window.PAVONINE_SERVER = 'http://pavonine-testing.com'
      window.PAVONINE_MIN = ''

      global.document = window.document
      global.IN_BROWSER = true
      global.navigator = window.navigator

      xmldom = require 'xmldom'
      global.DOMParser = xmldom.DOMParser
      global.XMLSerializer = xmldom.XMLSerializer

      global.jQuery = window.jQuery
      global.jQuery.Deferred = window.jQuery.Deferred

      Pavonine = require '../src/coffee/pavonine'
      fn(Pavonine)

      window.close()
  )

global.l = (code = '') ->
  "#{code}\n"
