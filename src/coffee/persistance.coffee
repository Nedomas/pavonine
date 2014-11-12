Persistance = module.exports = (->
  _ = require 'lodash'
  Databound = require 'databound'
  Model = require './model'
  Router = require './router'
  Memory = require './memory'

  setApi = (api_url) ->
    Databound.API_URL = api_url

  communicate = (action, attributes) ->
    throw new Error 'No model specified' unless attributes.model

    model = new Model(attributes)
    connection = new Databound('models')

    connection[action](model.serialize()).then (resp) ->
      new_attributes = if _.isObject(resp) then resp else {}
      metadata =
        model: model.model

      new_model = new Model(_.assign(new_attributes, metadata))

      Memory.setArray(new_model.plural, connection.takeAll())

      if _.isArray(resp)
        Databound::promise(connection.takeAll())
      else
        Databound::promise(new_model)

  act = (action, e, attributes) ->
    e.preventDefault()
    communicate(action, attributes)

  return {
    setApi: setApi
    act: act
    communicate: communicate
  }
)()
