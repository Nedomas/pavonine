Memory = module.exports = (->
  _ = require 'lodash'
  app_data = {}

  set = (data) ->
    app_data[data.model] = data

  setArray = (name, records) ->
    app_data[name] = records

  get = (model) ->
    app_data[model] || {}

  return {
    set: set
    setArray: setArray
    get: get
  }
)()
