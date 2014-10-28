Memory = module.exports = (->
  _ = require 'lodash'
  app_data = {}

  set = (data) ->
    app_data[data.model] = data

  get = (model) ->
    app_data[model] || {}

  return {
    set: set
    get: get
  }
)()
