Memory = module.exports = (->
  _ = require 'lodash'
  app_data = {}

  set = (step, data) ->
    app_data[step] ||= {}
    app_data[step][data.model] = data

  get = (step, model) ->
    app_data[step]?[model] || {}

  return {
    set: set
    get: get
  }
)()
