ReactMixin = module.exports = (->
  Router = require './router'
  Memory = require './memory'

  getInitialState: ->
    Memory.get(Router.current())
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
    Router.previous(@state)
  next: (e) ->
    e.preventDefault()
    Router.next(@state)
)()
