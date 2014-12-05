Persistance = module.exports = (->
  _ = require 'lodash'
  Databound = require 'databound'
  Databound.API_URL = window.PAVONINE_SERVER

  Model = require './model'
  StepMemory = require './step_memory'

  communicate = (action, attributes) ->
    throw new Error 'No model specified' unless attributes.model

    model = new Model(attributes)
    connection = new Databound 'models',
      app_token: window.PAVONINE_APP
      model: model.model

    connection[action](model.serialize()).then (resp) ->
      new_attributes = if _.isObject(resp) then resp else {}
      metadata =
        model: model.model

      new_model = new Model(_.assign(new_attributes, metadata))

      StepMemory.setArray(new_model.plural, connection.takeAll())

      if _.isArray(resp)
        Databound::promise(connection.takeAll())
      else
        Databound::promise(new_model)

  act = (action, e, attributes) ->
    e.preventDefault()
    communicate(action, attributes)

  return {
    act: act
    communicate: communicate
  }
)()
