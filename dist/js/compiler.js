(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Compiler;

  Compiler = module.exports = (function() {
    var LOADING_REGEX, LOGIN_REGEX, STEP_REGEX, findLoading, findLogin, hide, init, installMain, removeFromBody, scan, scanSteps, show;
    STEP_REGEX = /{{\#step\ (\d+)}}([\s\S]*?.+?[\s\S]*?){{\/step}}/g;
    LOGIN_REGEX = /{{\#login}}([\s\S]*?.+?[\s\S]*?){{\/login}}/g;
    LOADING_REGEX = /{{\#loading}}([\s\S]*?.+?[\s\S]*?){{\/loading}}/g;
    init = function() {
      return hide();
    };
    scan = function() {
      window.PAVONINE_STEPS = {};
      scanSteps();
      findLogin();
      findLoading();
      removeFromBody();
      installMain();
      return show();
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
      script.src = "" + window.PAVONINE_SERVER + "/cornflake.js";
      return window.document.body.appendChild(script);
    };
    removeFromBody = function() {
      return console.log(window.PAVONINE_STEPS);
    };
    findLogin = function() {
      var code, content, full_match, matched;
      code = window.document.body.innerHTML;
      matched = LOGIN_REGEX.exec(code);
      if (matched) {
        full_match = matched[0];
        content = matched[1];
        return window.PAVONINE_STEPS.login = content;
      }
    };
    findLoading = function() {
      var code, content, full_match, matched;
      code = window.document.body.innerHTML;
      matched = LOADING_REGEX.exec(code);
      if (matched) {
        full_match = matched[0];
        content = matched[1];
        return window.PAVONINE_STEPS.loading = content;
      }
    };
    scanSteps = function() {
      var code, content, full_match, matched, regexp, step, steps, _results;
      code = window.document.body.innerHTML;
      steps = [];
      regexp = STEP_REGEX;
      _results = [];
      while (true) {
        matched = regexp.exec(code);
        if (matched) {
          full_match = matched[0];
          step = matched[1];
          content = matched[2];
          _results.push(window.PAVONINE_STEPS[step] = content);
        } else {
          break;
        }
      }
      return _results;
    };
    return {
      init: init,
      scan: scan
    };
  })();

  Compiler.init();

  window.onload = function() {
    return Compiler.scan();
  };

}).call(this);

},{}]},{},[1])