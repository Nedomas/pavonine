describe 'Compiler', ->
  describe '#scan', ->
    it 'does not crash', ->
      mockDOM '', (Compiler) ->
        Compiler.scan()

    describe 'finding', ->
      it 'finds first step correctly', ->
        mockDOM '{{#step 1}}Hello{{/step}}', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS[1]).to.eq('Hello')

      it 'finds login step correctly', ->
        mockDOM '{{#login}}Please login{{/login}}', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS.login).to.eq('Please login')

      it 'finds loading step correctly', ->
        mockDOM '{{#loading}}Wait...{{/loading}}', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS.loading).to.eq('Wait...')

      it 'finds step correctly when nested in html', ->
        mockDOM '<p>Header</p>{{#step 1}}Hello{{/step}}<span>Footer</span>', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS[1]).to.eq('Hello')

      it 'finds multiple steps in a row', ->
        mockDOM '<p>Header</p>{{#step 1}}Hello{{/step}}{{#step 2}}Testing{{/step}}<span>Footer</span>', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS[1]).to.eq('Hello')
          expect(window.PAVONINE_STEPS[2]).to.eq('Testing')

      it 'finds multiple steps seperated by newline', ->
        html = '<p>Header</p>{{#step 1}}Hello{{/step}}\n' +
        '{{#step 2}}Testing{{/step}}<span>Footer</span>'

        mockDOM html, (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS[1]).to.eq('Hello')
          expect(window.PAVONINE_STEPS[2]).to.eq('Testing')

      it 'finds step with html markup', ->
        mockDOM '{{#step 1}}<p>Hello</p>{{/step}}', (Compiler) ->
          Compiler.scan()

          expect(window.PAVONINE_STEPS[1]).to.eq('<p>Hello</p>')

    describe 'placeholders', ->
      it 'puts steps', ->
        html = '<p>Header</p>{{#step 1}}Hello{{/step}}\n' +
        '{{#step 2}}Testing{{/step}}<span>Footer</span>'

        mockDOM html, (Compiler) ->
          Compiler.scan()

          expect(window.document.body.innerHTML).to.eq(
            '<p>Header</p><div step="1"></div>\n' +
            '<div step="2"></div><span>Footer</span><script src="http://pavonine-testing.com/cornflake.js"></script>'
          )

      it 'puts login and loading', ->
        html = '<p>Header</p>{{#login}}Hello{{/login}}\n' +
        '{{#loading}}Testing{{/loading}}<span>Footer</span>'

        mockDOM html, (Compiler) ->
          Compiler.scan()

          expect(window.document.body.innerHTML).to.eq(
            '<p>Header</p><div login=""></div>\n' +
            '<div loading=""></div><span>Footer</span><script src="http://pavonine-testing.com/cornflake.js"></script>'
          )
