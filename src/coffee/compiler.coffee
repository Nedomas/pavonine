window.Compiler = Compiler = module.exports = (->
  STEP_REGEX = /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g
  LOGIN_REGEX = /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g
  LOADING_REGEX = /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g
  steps = null
  login = {}
  loading = {}

  init = ->
    scanSteps()
    findLogin()
    findLoading()
    removeFromBody()
    installMain()
    show()

  stepContent = (i) ->
    for step in steps
      if parseInt(step.step) == i
        return step.content

    throw new Error("No step #{i}")

  loginContent = ->
    throw new Error('No login step') unless login.content
    login.content

  hide = ->
    document.write('<style class="hideBeforeCompilation" ' +
    'type="text/css">body {display:none;}<\/style>')

  show = ->
    document.body.style.display = 'block'

  installMain = ->
    script = document.createElement('script')
    script.src = "#{PAVONINE_SERVER}/cornflake.js"
    document.body.appendChild(script)

  removeFromBody = ->
    for step in steps
      document.body.innerHTML = document.body.innerHTML
        .replace(step.full_match, "<div step='#{step.step}'></div>")

    if login.full_match
      document.body.innerHTML = document.body.innerHTML
        .replace(login.full_match, "<div login=''></div>")

    if loading.full_match
      document.body.innerHTML = document.body.innerHTML
        .replace(loading.full_match, "<div loading=''></div>")

  findLogin = ->
    code = document.body.innerHTML
    matched = LOGIN_REGEX.exec(code)

    if matched
      full_match = matched[0]
      content = matched[1]

      login =
        full_match: full_match
        content: content

    login

  findLoading = ->
    code = document.body.innerHTML
    matched = LOADING_REGEX.exec(code)

    if matched
      full_match = matched[0]
      content = matched[1]

      loading =
        full_match: full_match
        content: content

    loading

  scanSteps = ->
    code = document.body.innerHTML
    steps = []
    regexp = STEP_REGEX

    loop
      matched = regexp.exec(code)

      if matched
        full_match = matched[0]
        step = matched[1]
        content = matched[2]

        steps.push
          full_match: full_match
          step: step
          content: content
      else
        break

    steps

  return {
    init: init
    hide: hide
    stepContent: stepContent
    loginContent: loginContent
  }
)()
Compiler.hide()

window.onload = ->
  Compiler.init()
