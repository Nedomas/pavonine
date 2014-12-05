sinon = require 'sinon'
Databound = require 'databound'
HandlebarsLookups = require '../src/coffee/handlebars/lookups'

describe 'MissingData', ->
  beforeEach ->
    HandlebarsLookups.clean()

  describe '#collections', ->
    it 'it should return unique missing collections', ->
      mockDOM '', ->
        MissingData = require '../src/coffee/missing_data'

        HandlebarsLookups.addCollection('messages')
        HandlebarsLookups.addCollection('messages')
        HandlebarsLookups.addCollection('users')

        expect(MissingData.collections()).to.eql(['messages', 'users'])

  describe '#get', ->
    it 'it should not load if no missing collections are present', ->
      mockDOM '', ->
        Databound::promise = mockedPromise('mocked_true')
        MissingData = require '../src/coffee/missing_data'

        MissingData.get().then (resp) ->
          expect(resp).to.eql('mocked_true')

    it 'it should load missing collections', ->
      mockDOM '', ->
        MissingData = require '../src/coffee/missing_data'
        DataLoader = require '../src/coffee/data_loader'
        sinon.stub(DataLoader, 'load', mockedPromise('loading_messages'))

        HandlebarsLookups.addCollection('messages')

        MissingData.get().then (resp) ->
          expect(resp).to.eql('loading_messages')
