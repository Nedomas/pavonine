HandlebarsManager = require '../../src/coffee/handlebars/manager'

describe 'Moment.js helpers', ->
  before ->
    HandlebarsManager.init()

  describe 'format', ->
    it 'should return a formatted string', ->
      html = "{{moment message.created_at format='YYYY-MM-DD'}}"
      expect(@compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{moment(this.state.message.created_at).format('YYYY-MM-DD')}\n" +
        "</div>"
      )

    it 'should work within blocks', ->
      html = "{{#each messages}}<p>Day: {{moment created_at format='DD'}}</p>{{/each}}"
      expect(@compile(html)).to.equal(
        "\n" +
        "<div>\n" +
        "{_.map(this.state.messages, function(record, i) {\n" +
        "return <p>Day: \n" +
        "<div>\n" +
        "{moment(record.created_at).format('DD')}\n" +
        "</div></p>\n" +
        "})}\n" +
        "</div>"
      )
