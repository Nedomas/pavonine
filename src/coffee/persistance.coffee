Persistance = module.exports = (->
  Databound = require 'databound'
  _ = require 'lodash'
  $ = require 'jquery'
  Router = require './router'

  setApi = (api_url) ->
    Databound.API_URL = api_url

  act = (action, e, attributes) ->
    e.preventDefault()
    throw new Error 'No model specified' unless attributes.model

    debugger
    connection = new Databound("#{attributes.model}s")
    connection[action](_.omit(attributes, 'model', 'step')).then (resp) ->
      record = if _.isObject(resp) then resp else null
      _.extend(record, model: attributes.model)
      Router.next(record)

  return {
    setApi: setApi
    act: act
  }
)()
