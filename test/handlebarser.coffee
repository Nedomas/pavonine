Handlebars = require 'handlebars'
HandlebarsManager = require '../src/coffee/handlebars/manager'
HandlebarsHelpers = require '../src/coffee/handlebars/helpers'

compile = (html) ->
  result = Handlebars.compile(html, trackIds: true)()
  result?.string || result

describe 'Handlebarser', ->
  describe 'patched helpers', ->
    before ->
      HandlebarsManager.init()

    describe 'generated from lodash', ->
      describe '#sortBy', ->
        it 'should return a string of collection nested in _.sortBy()', ->
          html = "{{sortBy messages 'created_at'}}"
          expect(compile(html)).to.equal(
            "\n<div>\n{_.sortBy(this.state.messages, 'created_at')}\n</div>"
          )

      describe '#first', ->
        it 'should return first element if without params', ->
          html = "{{first messages}}"
          expect(compile(html)).to.equal(
            "\n<div>\n{_.first(this.state.messages)}\n</div>"
          )

        it 'should return first element with state if as a block', ->
          html = "{{#first messages}}<p>{{content}}</p>{{/first}}"

          expect(compile(html)).to.equal(
            "<p>{_.first(this.state.messages).content}</p>"
          )
