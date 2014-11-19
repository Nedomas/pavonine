(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Pavonine,
    __slice = [].slice;

  Pavonine = (function() {
    var CUSTOM_HELPERS, hide, init, installMain, regexScan, replace, scan, show;
    CUSTOM_HELPERS = {
      step: /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g,
      login: /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g,
      loading: /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g
    };
    init = function() {
      return hide();
    };
    scan = function() {
      var name, regex;
      window.PAVONINE_STEPS = {};
      for (name in CUSTOM_HELPERS) {
        regex = CUSTOM_HELPERS[name];
        regexScan(regex, function(full_match, content, value) {
          window.PAVONINE_STEPS[value || name] = content;
          return replace(full_match, "<div " + name + "='" + value + "'></div>");
        });
      }
      installMain();
      return show();
    };
    regexScan = function(regex, fn) {
      var code, content, full_match, matched, regexp, value, _i, _results;
      code = window.document.body.innerHTML;
      regexp = regex;
      _results = [];
      while (true) {
        matched = regexp.exec(code);
        if (matched) {
          full_match = matched[0], value = 3 <= matched.length ? __slice.call(matched, 1, _i = matched.length - 1) : (_i = 1, []), content = matched[_i++];
          _results.push(fn(full_match, content, value[0] || ''));
        } else {
          break;
        }
      }
      return _results;
    };
    replace = function(full_match, replacement) {
      return window.document.body.innerHTML = window.document.body.innerHTML.replace(full_match, replacement);
    };
    hide = function() {
      return window.document.write('<style class="hideBeforeCompilation" ' + 'type="text/css">body {display:none;}<\/style>');
    };
    show = function() {
      return window.document.body.style.display = 'block';
    };
    installMain = function() {
      var script;
      script = window.document.createElement('script');
      script.src = "" + window.PAVONINE_SERVER + "/core.js";
      return window.document.body.appendChild(script);
    };
    return {
      init: init,
      scan: scan
    };
  })();

  Pavonine.init();

  window.onload = function() {
    return Pavnine.scan();
  };

  module.exports = Pavonine;

}).call(this);

},{}]},{},[1])