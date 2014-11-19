Compiler = module.exports = (->
  STEP_REGEX = /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g
  LOGIN_REGEX = /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g
  LOADING_REGEX = /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g

  init = ->
    hide()

  scan = ->
    window.PAVONINE_STEPS = {}

    scanSteps()
    findLogin()
    findLoading()
    removeFromBody()
    installMain()
    show()

  hide = ->
    window.document.write('<style class="hideBeforeCompilation" ' +
    'type="text/css">body {display:none;}<\/style>')

  show = ->
    window.document.body.style.display = 'block'

  installMain = ->
    script = window.document.createElement('script')
    script.src = "#{window.PAVONINE_SERVER}/cornflake.js"
    window.document.body.appendChild(script)

  removeFromBody = ->
    console.log window.PAVONINE_STEPS
#     for step in steps
#       document.body.innerHTML = document.body.innerHTML
#         .replace(step.full_match, "<div step='#{step.step}'></div>")
#
#     if login.full_match
#       document.body.innerHTML = document.body.innerHTML
#         .replace(login.full_match, "<div login=''></div>")
#
#     if loading.full_match
#       document.body.innerHTML = document.body.innerHTML
#         .replace(loading.full_match, "<div loading=''></div>")

  findLogin = ->
    code = window.document.body.innerHTML
    matched = LOGIN_REGEX.exec(code)

    if matched
      full_match = matched[0]
      content = matched[1]

      window.PAVONINE_STEPS.login = content

  findLoading = ->
    code = window.document.body.innerHTML
    matched = LOADING_REGEX.exec(code)

    if matched
      full_match = matched[0]
      content = matched[1]

      window.PAVONINE_STEPS.loading = content

  scanSteps = ->
    code = window.document.body.innerHTML
    steps = []
    regexp = STEP_REGEX

    loop
      matched = regexp.exec(code)

      if matched
        full_match = matched[0]
        step = matched[1]
        content = matched[2]

        window.PAVONINE_STEPS[step] = content
      else
        break

  return {
    init: init
    scan: scan
  }
)()
Compiler.init()

window.onload = ->
  Compiler.scan()
