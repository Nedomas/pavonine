Core = (->
  HandlebarsManager = require './handlebars/manager'
  Router = require './router'
  Facebook = require './facebook'

  init = ->
    HandlebarsManager::init()
    Router.change(1)
    Facebook.init()

  return {
    init: init
  }
)()

Core.init()

module.exports = Core
