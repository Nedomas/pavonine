# This is the starting point.
# It is included directly in the page from Rails backend app like this:
#
# ```
# window.PAVONINE_APP = 'IVnv'
# window.PAVONINE_SERVER = 'http://pavonine.herokuapp.com'
# window.PAVONINE_FB_APP_ID = '776916785684160'
# window.PAVONINE_MIN = ''
#
# [this Pavonine module]
#
# window.Pavonine.init()
# window.onload = -> window.Pavonine.scan()

class Pavonine
  CUSTOM_HELPERS =
    step: /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g
    login: /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g
    loading: /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g

  @init: ->
    @hide()

  # scan for steps, login and loading parts
  # load the content of it into window.PAVONINE_STEPS
  # put div placeholders in the places we found them
  @scan: ->
    window.PAVONINE_STEPS = {}

    for name, regex of CUSTOM_HELPERS
      @regexScan regex, (full_match, content, value) =>
        window.PAVONINE_STEPS[value || name] = content
        @replace(full_match, "<div #{name}='#{value}'></div>")

    @installMain()
    @show()

  @regexScan: (regex, fn) ->
    code = window.document.body.innerHTML
    regexp = regex

    loop
      matched = regexp.exec(code)

      if matched
        [full_match, value..., content] = matched
        fn(full_match, content, value[0] || '')
      else
        break

  @replace: (full_match, replacement) ->
    window.document.body.innerHTML = window.document.body.innerHTML
      .replace(full_match, replacement)

  # hide the page (so we don't see handlebars ({}) flashing around)
  @hide: ->
    window.document.write('<style class="hideBeforeCompilation" ' +
    'type="text/css">body {display:none;}<\/style>')

  # set the page visible again
  @show: ->
    window.document.body.style.display = 'block'

  # load Core
  @installMain: ->
    script = window.document.createElement('script')
    script.src = "#{window.PAVONINE_SERVER}/core#{window.PAVONINE_MIN}.js"
    window.document.body.appendChild(script)

module.exports = Pavonine
window.Pavonine = Pavonine
