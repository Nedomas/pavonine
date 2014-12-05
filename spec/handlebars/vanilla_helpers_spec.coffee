HandlebarsManager = require '../../src/coffee/handlebars/manager'

describe 'Base helpers', ->
  before ->
    HandlebarsManager.init()

  describe '#reverse', ->
    it 'should return collection in a _.map', ->
      html = "{{reverse messages}}"
      expect(compile(html)).to.equal(
        l() +
        l('<div>') +
        l('{this.state.messages.reverse()}') +
         ('</div>')
      )

  describe '#reverse with #each', ->
    it 'should return collection in a _.map', ->
      html = "{{#each (reverse messages)}}<p>{{content}}</p>{{/each}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.map(this.state.messages.reverse(), function(record, i) {\n" +
        "return <p>{record.content}</p>\n" +
        "})}\n" +
        "</div>"
      )
