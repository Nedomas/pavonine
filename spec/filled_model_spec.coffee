sinon = require 'sinon'
FilledModel = require '../src/coffee/filled_model'
HandlebarsMock = require '../src/coffee/handlebars/mock'
StepMemory = require '../src/coffee/step_memory'

describe 'FilledModel', ->
  before ->
    empty_attributes = {
      user: {
        name: '',
        post: {
          content: ''
        }
      }
    }

    sinon.stub HandlebarsMock, 'getEmpty', ->
      empty_attributes

  describe '#fillFromEmptyMock', ->
    it 'it should return empty attributes', ->
      filled_model = new FilledModel
      expect(filled_model.attributes).to.eql {
        user: {
          name: '',
          post: {
            content: ''
          }
        }
      }

  describe '#fillFromMemory', ->
    before ->
      @stubbed_memory = sinon.stub StepMemory, 'get', (name) ->
        if name == 'user.name'
          'John'
        else if name == 'user'
          {
            id: 15
            model: 'user'
            post: {
            }
          }
        else if name == 'user.post'
          { content: 'Hello' }

    after ->
      @stubbed_memory.restore()

    it 'should fill elementary value', ->
      filled_model = new FilledModel
      expect(filled_model.attributes.user.name).to.eql('John')

    it 'should fill relation with id', ->
      filled_model = new FilledModel
      expect(filled_model.attributes).to.eql {
        user: {
          id: 15
          model: 'user'
          name: 'John'
          post: {
            content: 'Hello'
            user_id: 15
          }
        }
      }
