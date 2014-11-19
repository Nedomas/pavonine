HandlebarsManager = require '../../src/coffee/handlebars/manager'

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

  describe '#if', ->
    it 'should work with true condition only', ->
      html = "{{#if current_user.logged_in}}<p>Hello</p>{{/if}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{this.state.current_user.logged_in ? <div><p>Hello</p></div> : undefined}\n" +
        "</div>"
      )

    it 'should work with else', ->
      html = "{{#if current_user.logged_in}}<p>Hello</p>{{else}}<p>Log in</p>{{/if}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{this.state.current_user.logged_in ? <div><p>Hello</p></div> : <div><p>Log in</p></div>}\n" +
        "</div>"
      )

    it 'should work with empty true condition', ->
      html = "{{#if current_user.logged_in}}{{else}}<p>Log in</p>{{/if}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{this.state.current_user.logged_in ? undefined : <div><p>Log in</p></div>}\n" +
        "</div>"
      )

  describe '#with', ->
    it 'should scope attributes', ->
      html = "{{#with message}}<p>{{content}}</p>{{/with}}"
      expect(compile(html)).to.equal(
        "<p>{this.state.message.content}</p>"
      )

    it 'should scope actions', ->
      html = "{{#with message}}<button onclick='{{create}}'>Save</button>{{/with}}"
      expect(compile(html)).to.equal(
        "<button onclick='{_.partial(this.action, 'message.create')}'>Save</button>"
      )
