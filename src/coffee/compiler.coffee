Compiler = module.exports = (->
  CUSTOM_HELPERS =
    step: /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g
    login: /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g
    loading: /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g

  init = ->
    hide()

  scan = ->
    window.PAVONINE_STEPS = {}

#     regexScan STEP_REGEX, (full_match, step, content) ->
#       window.PAVONINE_STEPS[step] = content
#       replace(full_match, "<div step='#{step}'></div>")
#
    for name, regex of CUSTOM_HELPERS
      regexScan regex, (full_match, content, value) ->
        window.PAVONINE_STEPS[value || name] = content
        replace(full_match, "<div #{name}='#{value}'></div>")

    console.log window.PAVONINE_STEPS
    installMain()
    show()

  regexScan = (regex, fn) ->
    code = window.document.body.innerHTML
    regexp = regex

    loop
      matched = regexp.exec(code)

      if matched
        [full_match, value..., content] = matched
        fn(full_match, content, value[0] || '')
      else
        break

  replace = (full_match, replacement) ->
    window.document.body.innerHTML = window.document.body.innerHTML
      .replace(full_match, replacement)

  hide = ->
    window.document.write('<style class="hideBeforeCompilation" ' +
    'type="text/css">body {display:none;}<\/style>')

  show = ->
    window.document.body.style.display = 'block'

  installMain = ->
    script = window.document.createElement('script')
    script.src = "#{window.PAVONINE_SERVER}/cornflake.js"
    window.document.body.appendChild(script)

  return {
    init: init
    scan: scan
  }
)()
Compiler.init()

window.onload = ->
  Compiler.scan()
