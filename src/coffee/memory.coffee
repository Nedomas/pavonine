Memory = module.exports = (->
  _ = require 'lodash'
  app_data = {}

  set = (data) ->
    app_data[data.model] = data

  setForever = (data) ->
    set(data)
    localStorage[data.model] = JSON.stringify(data)

  getForever = (model) ->
    json = localStorage[model]
    return unless json
    data = JSON.parse(json)
    set(data)

  setArray = (name, records) ->
    app_data[name] = records

  get = (model) ->
    app_data[model] || {}

  has = (key) ->
    !!app_data[key]

  return {
    set: set
    setForever: setForever
    setArray: setArray
    get: get
    getForever: getForever
    has: has
  }
)()
