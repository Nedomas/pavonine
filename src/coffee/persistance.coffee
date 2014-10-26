Persistance = module.exports = (->
  Databound = require 'databound'
  _ = require 'lodash'
  $ = require 'jquery'
  UI = require './ui'

  setApi = (api_url) ->
    Databound.API_URL = api_url

  act = (action, e, attributes) ->
    e.preventDefault()
    model_element = $(e.target).parent('*[data-model]')
    throw new Error 'No model specified' if _.isEmpty(model_element)
    model = model_element.data('model')

    connection = new Databound("#{model}s")
    connection[action](attributes).then (resp) ->
      record = if _.isObject(resp) then resp else null
      UI.nextState(record)

  return {
    setApi: setApi
    act: act
  }
)()
