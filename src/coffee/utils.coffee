# random utilities which probably should be elsewhere
module.exports =
class Utils
  $ = require 'jquery'

  @failedPromise: (result) ->
    deferred = $.Deferred()
    deferred.reject result
    deferred.promise()

  @singularize: (string) ->
    string.replace(/s$/, '')

  @pathString: (array) ->
    array.join('.')
