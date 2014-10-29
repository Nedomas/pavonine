ReactMixin = module.exports = (->
  Router = require './router'
  Model = require './model'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Persistance = require './persistance'
  Replacer = require './replacer'

  getInitialState: ->
    Model.main().attributes
  onChange: (path, e) ->
    new_state = _.clone(@state)
    _.deepSet(new_state, Replacer.toAttribute(path), e.target.value)
    @setState(new_state)
  relationshipOnChange: (attribute, e) ->
    new_attributes = _.clone(@state)
    _.deepSet(new_attributes, attribute, e.target.value)
    @setState(new_attributes)
  action: (path, e) ->
    [model_path..., action] = path.split('.')
    model_path_str = model_path.join('.')
    attributes = _.deepGet(@state, model_path_str)
    attributes.model = _.last(model_path_str.split('.'))
    Persistance.act(action, e, attributes)
  # previous: (e) ->
  #   e.preventDefault()
  #   Router.previous(@state)
  # next: (e) ->
  #   e.preventDefault()
  #   Router.next(@state)
)()
