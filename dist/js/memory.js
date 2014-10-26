(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Memory;

  Memory = module.exports = (function() {
    var app_data, get, set;
    app_data = {
      0: {}
    };
    set = function(state, state_data) {
      return app_data[state] = state_data;
    };
    get = function(state) {
      return app_data[state];
    };
    return {
      set: set,
      get: get
    };
  })();

}).call(this);

},{}]},{},[1])