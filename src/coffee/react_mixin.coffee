ReactMixin = module.exports = (->
  Router = require './router'
  Model = require './model'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Persistance = require './persistance'
  Replacer = require './replacer'
  Facebook = require './facebook'

  getInitialState: ->
    Model.main().attributes
  onChange: (path, e) ->
    new_state = _.clone(@state)
    _.deepSet(new_state, Replacer.toAttribute(path), e.target.value)
    @setState(new_state)
  action: (path, e) ->
    [model_path..., action] = path.split('.')
    model_path_str = model_path.join('.')
    return Facebook.login() if model_path_str == 'facebook'
    return Router.next() if action == 'next'
    return Router.previous() if action == 'previous'

    attributes = _.deepGet(@state, model_path_str)
    attributes.model = _.last(model_path_str.split('.'))

    Persistance.act(action, e, attributes).then (new_model) ->
      Router.next(new_model.attributes)
)()
