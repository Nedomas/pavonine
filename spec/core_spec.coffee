describe 'Core', ->
  it 'test', ->
    html = "{{#step 1}}<p>{{message.content}}</p>{{/step}}"
    mockDOM html, (Pavonine) ->
      Pavonine.scan()

      Core = require '../src/coffee/core'
      console.log 'b', window.document.body

      # expect(converter.componentCode()).to.equal()
