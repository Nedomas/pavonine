Utils = (->
  $ = require 'jquery'

  failedPromise = (result) ->
    deferred = $.Deferred()
    deferred.reject result
    deferred.promise()

  singularize = (string) ->
    string.replace(/s$/, '')

  return {
    failedPromise: failedPromise
    singularize: singularize
  }
)()

module.exports = Utils
