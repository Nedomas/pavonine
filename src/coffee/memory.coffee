Memory = module.exports = (->
  app_data = {}

  set = (state, state_data) ->
    app_data[state] = state_data

  get = (state) ->
    app_data[state] || {}

  return {
    set: set
    get: get
  }
)()
