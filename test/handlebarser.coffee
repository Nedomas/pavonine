Handlebarser = require '../src/coffee/handlebarser'
Handlebars = require 'handlebars'

compile = (html) ->
  result = Handlebars.compile(html, trackIds: true)()
  result?.string || result

describe 'Handlebarser', ->
  describe 'patched helpers', ->
    before ->
      Handlebarser.patch()

    describe 'generated from lodash', ->
      describe '#sortBy', ->
        it 'should return a string of collection nested in _.sortBy()', ->
          html = "{{sortBy messages 'created_at'}}"
          expect(compile(html)).to.equal("_.sortBy(messages, 'created_at')")

      describe '#first', ->
        it 'should return first element if without params', ->
          html = "{{first messages}}"
          expect(compile(html)).to.equal("_.first(messages)")

        it 'should return first element with state if as a block', ->
          html = "{{#first messages}}<p>{{content}}</p>{{/first}}"

          expect(compile(html)).to.equal(
            "<div>{<p>{_.first(this.state.messages).content}</p>}</div>"
          )
