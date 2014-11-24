Pavonine = (->
  CUSTOM_HELPERS =
    step: /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g
    login: /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g
    loading: /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g

  init = ->
    hide()

  scan = ->
    window.PAVONINE_STEPS = {}

    for name, regex of CUSTOM_HELPERS
      regexScan regex, (full_match, content, value) ->
        window.PAVONINE_STEPS[value || name] = content
        replace(full_match, "<div #{name}='#{value}'></div>")

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
    script.src = "#{window.PAVONINE_SERVER}/core#{window.PAVONINE_MIN}.js"
    window.document.body.appendChild(script)

  return {
    init: init
    scan: scan
  }
)()

module.exports = Pavonine
window.Pavonine = Pavonine
