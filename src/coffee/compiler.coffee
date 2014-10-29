window.Compiler = Compiler = module.exports = (->
  # STEP_REGEX = /\{\#step\ (\d+)}(.+?)\{\#end\}/g
  STEP_REGEX = /\{\#step\ (\d+)}([\s\S]*?)(.+?)([\s\S]*?)\{\#end\}/g
  steps = null

  init = ->
    console.log('Compiling')
    scanSteps()
    removeFromBody()
    installMain()
    console.log('Compiled')
    show()

  getSteps = ->
    steps

  hide = ->
    document.write('<style class="hideBeforeCompilation" ' +
    'type="text/css">body {display:none;}<\/style>')

  show = ->
    document.body.style.display = 'block'

  installMain = ->
    script = document.createElement('script')
    script.src = 'js/cornflake.js'
    document.body.appendChild(script)

  removeFromBody = ->
    for step in steps
      document.body.innerHTML = document.body.innerHTML
        .replace(step.full_match, '')

  scanSteps = ->
    code = document.body.innerHTML
    steps = []
    regexp = STEP_REGEX

    loop
      matched = regexp.exec(code)

      if matched
        full_match = matched[0]
        step = matched[1]
        content = matched[4]

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
    getSteps: getSteps
  }
)()
Compiler.hide()

window.onload = ->
  Compiler.init()
