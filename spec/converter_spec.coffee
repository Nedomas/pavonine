HandlebarsManager = require '../src/coffee/handlebars/manager'

describe 'Converter', ->
  before ->
    HandlebarsManager.init()

  describe 'no nesting', ->
    it 'should scope simple attributes', ->
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

  describe 'single level nesting', ->
    it '#with', ->
      html = "{{#with user}}<p>{{message.content}}</p>{{/with}}"
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
          l("      React.DOM.div(null, " +
                     "React.DOM.div(null, " +
                       "React.DOM.p(null, this.state.user.message.content)))") +
          l("    );") +
          l("  }") +
           ("});")
        )

    it '#each', ->
      html = "{{#each user}}<p>{{message.content}}</p>{{/each}}"
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
          l("      React.DOM.div(null, ") +
          l("        _.map(this.state.user, function(record, i) {") +
          l("        return React.DOM.p(null, record.message.content)") +
          l("        })") +
          l("      )") +
          l("    );") +
          l("  }") +
           ("});")
        )

  describe 'double nesting', ->
    it '#with and #with', ->
      html = "{{#with country}}{{#with user}}<p>{{message.content}}</p>{{/with}}{{/with}}"
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
          l("      React.DOM.div(null, React.DOM.div(null, React.DOM.div(null, React.DOM.div(null, React.DOM.p(null, this.state.country.user.message.content)))))") +
          l("    );") +
          l("  }") +
           ("});")
        )

    it '#with and #each', ->
      html = "{{#with country}}{{#each users}}<p>{{message.content}}</p>{{/each}}{{/with}}"
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
          l("      React.DOM.div(null, React.DOM.div(null, ") +
          l("          React.DOM.div(null, ")+
          l("            _.map(this.state.users, function(record, i) {") +
          l("            return React.DOM.p(null, record.message.content)") +
          l("            })") +
          l("          )))") +
          l("    );") +
          l("  }") +
           ("});")
        )
