HandlebarsManager = require '../src/coffee/handlebars/manager'

describe 'Converter', ->
  before ->
    HandlebarsManager.init()

  describe 'no nesting', ->
    it 'should scope simple attributes', ->
      # Cant load up DOMParser
      html = "<p>{{message.content}}</p>"
      mockDOM html, (Pavonine) ->
        Converter = require '../src/coffee/converter'
        converter = new Converter('test_1', html)

        expect(converter.componentCode()).to.equal(
          l("/** @jsx React.DOM */") +
          l("var test_1 = React.createClass({displayName: 'test_1',") +
          l("  mixins: [ReactMixin],") +
          l("  render: function() {") +
          l("    return (") +
          l() +
          l("      React.DOM.p(null, this.state.message.content)") +
          l("    );") +
          l("  }") +
           ("});")
        )
