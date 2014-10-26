ReactMixin = module.exports = (->
  Memory = require './memory'

  getInitialState: ->
    UI = require './ui'
    Memory.get(UI.currentState() - 1)
  onChange: (attribute, e) ->
    attribute_hash = {}
    attribute_hash[attribute] = e.target.value
    @setState(attribute_hash)
  create: (e) ->
    Persistance = require './persistance'
    Persistance.act('create', e, @state)
  update: (e) ->
    Persistance = require './persistance'
    Persistance.act('update', e, @state)
  destroy: (e) ->
    Persistance = require './persistance'
    Persistance.act('destroy', e, @state)
  previous: (e) ->
    e.preventDefault()
    UI = require './ui'
    UI.previousState(@state)
  next: (e) ->
    e.preventDefault()
    UI = require './ui'
    UI.nextState(@state)
)()
