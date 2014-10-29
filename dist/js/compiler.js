(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Compiler;

  window.Compiler = Compiler = module.exports = (function() {
    var STEP_REGEX, getSteps, hide, init, installMain, removeFromBody, scanSteps, show, steps;
    STEP_REGEX = /\{\#step\ (\d+)}([\s\S]*?)(.+?)([\s\S]*?)\{\#end\}/g;
    steps = null;
    init = function() {
      console.log('Compiling');
      scanSteps();
      removeFromBody();
      installMain();
      console.log('Compiled');
      return show();
    };
    getSteps = function() {
      return steps;
    };
    hide = function() {
      return document.write('<style class="hideBeforeCompilation" ' + 'type="text/css">body {display:none;}<\/style>');
    };
    show = function() {
      return document.body.style.display = 'block';
    };
    installMain = function() {
      var script;
      script = document.createElement('script');
      script.src = 'js/cornflake.js';
      return document.body.appendChild(script);
    };
    removeFromBody = function() {
      var step, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        _results.push(document.body.innerHTML = document.body.innerHTML.replace(step.full_match, ''));
      }
      return _results;
    };
    scanSteps = function() {
      var code, content, full_match, matched, regexp, step;
      code = document.body.innerHTML;
      steps = [];
      regexp = STEP_REGEX;
      while (true) {
        matched = regexp.exec(code);
        if (matched) {
          full_match = matched[0];
          step = matched[1];
          content = matched[4];
          steps.push({
            full_match: full_match,
            step: step,
            content: content
          });
        } else {
          break;
        }
      }
      return steps;
    };
    return {
      init: init,
      hide: hide,
      getSteps: getSteps
    };
  })();

  Compiler.hide();

  window.onload = function() {
    return Compiler.init();
  };

}).call(this);

},{}]},{},[1])