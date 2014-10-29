ReactMixin = module.exports = (->
  Router = require './router'
  Model = require './model'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Persistance = require './persistance'

  getInitialState: ->
    Model.main().attributes
  onChange: (attribute, e) ->
    new_attributes = _.clone(@state)
    new_attributes[attribute] = e.target.value
    @setState(new_attributes)
  relationshipOnChange: (attribute, e) ->
    new_attributes = _.clone(@state)
    _.deepSet(new_attributes, attribute, e.target.value)
    @setState(new_attributes)
  relationshipAction: (model, action, e) ->
    debugger
    Persistance.act(action, e, @state[model], model)
  create: (e) ->
    Persistance.act('create', e, @state)
  update: (e) ->
    Persistance.act('update', e, @state)
  destroy: (e) ->
    Persistance.act('destroy', e, @state)
  previous: (e) ->
    e.preventDefault()
    Router.previous(@state)
  next: (e) ->
    e.preventDefault()
    Router.next(@state)
)()
