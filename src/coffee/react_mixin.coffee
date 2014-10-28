ReactMixin = module.exports = (->
  Router = require './router'
  Model = require './model'
  _ = require 'lodash'
  _.mixin require('lodash-deep')

  getInitialState: ->
    Model.current()
  onChange: (attribute, e) ->
    console.log(attribute)
    attribute_hash = {}
    _.deepSet(attribute_hash, attribute, e.target.value)
    console.log(attribute_hash)
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
