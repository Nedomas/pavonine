describe 'Converter', ->
  describe 'no nesting', ->
    it 'should scope simple attributes', ->
#       Cant load up DOMParser
#       html = "<p>{{message.content}}</p>"
#       mockDOM html, (Pavonine) ->
#         Converter = require '../src/coffee/converter'
#
#         expect(Converter.htmlToReactComponent('test_1', html)).to.equal(
#           "<div><div><p>{this.state.message.content}</p></div></div>"
#         )
