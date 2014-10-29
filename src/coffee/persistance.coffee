Persistance = module.exports = (->
  _ = require 'lodash'
  Databound = require 'databound'
  Model = require './model'
  Router = require './router'

  setApi = (api_url) ->
    Databound.API_URL = api_url

  act = (action, e, attributes) ->
    e.preventDefault()
    throw new Error 'No model specified' unless attributes.model

    model = new Model(attributes)
    connection = new Databound(model.plural)

    connection[action](model.serialize()).then (resp) ->
      new_attributes = if _.isObject(resp) then resp else {}
      metadata =
        model: model.model
        relationships: new_attributes.relationships

      new_model = new Model(_.assign(new_attributes, metadata))
      Router.next(new_model.attributes)

  return {
    setApi: setApi
    act: act
  }
)()
