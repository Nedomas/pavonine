sinon = require 'sinon'

describe 'MissingData', ->
#   before ->
#     empty_attributes = {
#       user: {
#         name: '',
#         post: {
#           content: ''
#         }
#       }
#     }
#
#     sinon.stub HandlebarsMock, 'getEmpty', ->
#       empty_attributes

  describe '#collections', ->
    it 'it should return unique missing collections', ->
      mockDOM '', ->
        HandlebarsLookups = require '../src/coffee/handlebars/lookups'
        MissingData = require '../src/coffee/missing_data'

        HandlebarsLookups.addCollection('messages')
        HandlebarsLookups.addCollection('messages')
        HandlebarsLookups.addCollection('users')

        expect(MissingData.collections()).to.eql(['users', 'messages'])
