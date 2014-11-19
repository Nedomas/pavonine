HandlebarsManager = require '../../src/coffee/handlebars/manager'

describe 'Lodash helpers', ->
  before ->
    manager = HandlebarsManager.init()

  describe 'without params', ->
    it '#first', ->
      html = "{{first messages}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.first(this.state.messages)}\n" +
        "</div>"
      )

  describe 'with params', ->
    it '#sortBy', ->
      html = "{{sortBy messages 'created_at'}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.sortBy(this.state.messages, 'created_at')}\n" +
        "</div>"
      )

  describe 'nested as context', ->
    it '#last and #sortBy', ->
      html = "{{last (sortBy messages 'stars')}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.last(_.sortBy(this.state.messages, 'stars'))}\n" +
        "</div>"
      )

  describe 'double nesting as context', ->
    it '#last, #sortBy and #uniq', ->
      html = "{{last (sortBy (uniq messages 'current_user_id') 'stars')}}"
      expect(compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.last(" +
        "_.sortBy(" +
        "_.uniq(this.state.messages, 'current_user_id'), 'stars')" +
        ")" +
        "}\n" +
        "</div>"
      )

  describe 'simple block', ->
    it '#max', ->
      html = "{{#max messages 'stars'}}<p>Max stars: {{stars}}</p>{{/max}}"
      expect(compile(html)).to.equal(
        "<p>Max stars: {_.max(this.state.messages, 'stars').stars}</p>"
      )

  describe 'nested as block context', ->
    it '#last and #sortBy', ->
      html = "{{#last (sortBy messages 'stars')}}<p>{{content}}</p>{{/last}}"
      expect(compile(html)).to.equal(
        "<p>{_.last(_.sortBy(this.state.messages, 'stars')).content}</p>"
      )
