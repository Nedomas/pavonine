# mixin included into every React component
module.exports =
class ReactMixin
  Router = require './router'
  Model = require './model'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Persistance = require './persistance'
  Replacer = require './replacer'
  Facebook = require './facebook'

  # a default React initial state hook to load the component data
  @getInitialState: ->
    Model.filled().attributes

  # onChange={_.partial(@onChange, 'this.state.user.name')} is attached to every
  # input with change binding
  @onChange: (path, e) ->
    new_state = _.clone(@state)
    _.deepSet(new_state, Replacer.toAttribute(path), e.target.value)
    @setState(new_state)

  # onClick={_.partial(@action, 'this.state.user.create')} is attached to every
  # input with action binding
  @action: (path, e) ->
    [model_path..., action] = path.split('.')

    return Facebook.login() if action == 'facebook'
    return Router.next() if action == 'next'
    return Router.previous() if action == 'previous'

    model_path_str = model_path.join('.')
    attributes = _.deepGet(@state, model_path_str)
    attributes.model = _.last(model_path_str.split('.'))

    Persistance.act(action, e, attributes).then (new_model) ->
      Router.next(new_model.attributes)
