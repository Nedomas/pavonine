Utils = (->
  $ = require 'jquery'

  failedPromise = (result) ->
    deferred = $.Deferred()
    deferred.reject result
    deferred.promise()

  singularize = (string) ->
    string.replace(/s$/, '')

  pathString = (array) ->
    array.join('.')

  return {
    failedPromise: failedPromise
    singularize: singularize
    pathString: pathString
  }
)()

module.exports = Utils
