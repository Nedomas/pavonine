describe 'Compiler', ->
  describe '#scan', ->
    it 'does not crash', ->
      mockDOM '', ->
        Compiler = require '../src/coffee/compiler'
        Compiler.scan()

    it 'finds first step correctly', ->
      mockDOM '{{#step 1}}Hello{{/step}}', ->
        Compiler = require '../src/coffee/compiler'
        Compiler.scan()

        expect(window.PAVONINE_STEPS[1]).to.eq('Hello')
