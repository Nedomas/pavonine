Persistance = module.exports = (->
  Databound = require 'databound'
  _ = require 'lodash'
  $ = require 'jquery'
  Router = require './router'
  Model = require './model'

  setApi = (api_url) ->
    Databound.API_URL = api_url

  act = (action, e, attributes) ->
    e.preventDefault()
    throw new Error 'No model specified' unless Model.name()

    connection = new Databound("#{Model.name()}s")
    models = Model.forBackend(attributes)
    requests = _.map models, (model) ->
      connection

    debugger
    connection[action](models.main).then (resp) ->
      record = if _.isObject(resp) then resp else null
      _.extend(record, model: Model.name())
      Router.next(record)

  return {
    setApi: setApi
    act: act
  }
)()
