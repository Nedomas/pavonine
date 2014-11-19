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
      fn()
      window.close()
  )
