HandlebarsManager = require '../../../src/coffee/handlebars/manager'
compile = require '../compile'

describe 'Base helpers', ->
  before ->
    HandlebarsManager.init()

  describe '#each', ->
    it 'should return collection in a _.map', ->
      html = "{{#each messages}}<p>{{content}}</p>{{/each}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.map(this.state.messages, function(record, i) {\n" +
        "return <p>{record.content}</p>\n" +
        "})}\n" +
        "</div>"
      )

    it 'nested collection', ->
      html = "{{#each (sortBy messages 'date')}}<p>{{content}}</p>{{/each}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.map(_.sortBy(this.state.messages, 'date'), function(record, i) {\n" +
        "return <p>{record.content}</p>\n" +
        "})}\n" +
        "</div>"
      )

    it 'should work with else as empty collection', ->
      html = "{{#each messages}}<p>{{content}}</p>{{else}}<p>No messages</p>{{/each}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{this.state.messages.length ? (_.map(this.state.messages, function(record, i) {\n" +
        "return <p>{record.content}</p>\n" +
        "})) : (<p>No messages</p>)}\n" +
        "</div>"
      )

    it 'should work with else only', ->
      html = "{{#each messages}}{{else}}<p>No messages</p>{{/each}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{this.state.messages.length ? (_.map(this.state.messages, function(record, i) {\n" +
        "return \n" +
        "})) : (<p>No messages</p>)}\n" +
        "</div>"
      )
