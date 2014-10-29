window.Cornflake = Cornflake = module.exports = (->
  Handlebars = require 'handlebars'
  _ = require 'lodash'
  _.mixin require('lodash-deep')
  Persistance = require './persistance'
  Router = require './router'
  Replacer = require './replacer'
  lookups = []

  init = ->
    console.log('Here and now')
    configure()
    Router.change(1)
    Handlebarser.patch()
    # Facebook.init()

  configure = ->
    # Persistance.setApi('http://cornflake-backend.herokuapp.com')
    Persistance.setApi('http://10.30.0.1:3000')
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))
    overrideHandlebars()

  getReactMock = ->
    result = {}
    _.each lookups, (lookup) ->
      _.deepSet(result, lookup, "{#{toState(lookup)}}")

    result

  toState = (initial) ->
    "this.state.#{initial}"

      # debugger
      # self_str = "_this.state.#{context}"
      # records = _.deepGet(options.data.root, context)
      # return "{#{self_str}}" unless records
      # keys = _.keys(records[0])
      # attributes = _.inject keys, (memo, key) ->
      #   memo[key] = "{#{self_str}[i].#{key}}"
      #   memo
      # , {}
      # debugger
#     Handlebars.Compiler::ID = (id) ->
#       this.addDepth(id.depth)
#       this.opcode('getContext', id.depth)
#
#       name = id.parts[0]
#       if (!name)
#          #Context reference, i.e. `{{foo .}}` or `{{foo ..}}`
#         this.opcode('pushContext')
#       else
#         debugger
#         this.opcode('lookupOnContext', id.parts, id.falsy, id.isScoped);

      # debugger
#       original = mustache.id.original
#       mustache.id.idName = "{this.state.#{original}}"
#       mustache.id.string = "{this.state.#{original}}"
#       mustache.id.stringModeValue = "{this.state.#{original}}"
#       mustache.id.parts = ["{this.state.#{original}}"]
#
#       @sexpr(mustache.sexpr)
#
#       if mustache.escaped && !@options.noEscape
#         @opcode('appendEscaped')
#       else
#         @opcode('append')

      # debugger
#       self_str = "_this.state.#{context}"
#       records = _.deepGet(options.data.root, context)
#       return "{#{self_str}}" unless records
#       keys = _.keys(records[0])
#       attributes = _.inject keys, (memo, key) ->
#         memo[key] = "{#{self_str}[i].#{key}}"
#         memo
#       , {}
#       "{var _this = this; _.map(#{self_str}, function(record, i) {" +
#       " return '#{options.fn(attributes)}'" +
#       '})}'
#

  return {
    init: init
    getReactMock: getReactMock
  }
)()

Cornflake.init()

Facebook = (->
  $ = require 'jquery'

  init = ->
    $.ajaxSetup
      cache: true
    $.getScript '//connect.facebook.net/en_UK/all.js', ->
      FB.init
        appId: '776916785684160'
        xfbml: true
        version: 'v2.1'
      FB.login(loggedIn, scope: 'user_about_me')

  loggedIn = (r) ->
    console.log r
    debugger

  return {
    init: init
  }
)()
