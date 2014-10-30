(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Compiler;

  window.Compiler = Compiler = module.exports = (function() {
    var LOGIN_REGEX, STEP_REGEX, findLogin, hide, init, installMain, login, loginContent, removeFromBody, scanSteps, show, stepContent, steps;
    STEP_REGEX = /{{\#step\ (\d+)}}([\s\S]*?)(.+?)([\s\S]*?){{\/step}}/g;
    LOGIN_REGEX = /{{\#login}}([\s\S]*?)(.+?)([\s\S]*?){{\/login}}/;
    steps = null;
    login = {};
    init = function() {
      console.log('Compiling');
      scanSteps();
      findLogin();
      removeFromBody();
      installMain();
      console.log('Compiled');
      return show();
    };
    stepContent = function(i) {
      var step, _i, _len;
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        if (parseInt(step.step) === i) {
          return step.content;
        }
      }
      throw new Error("No step " + i);
    };
    loginContent = function() {
      return login.content;
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
      var step, _i, _len;
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        document.body.innerHTML = document.body.innerHTML.replace(step.full_match, "<div step='" + step.step + "'></div>");
      }
      if (login.full_match) {
        return document.body.innerHTML = document.body.innerHTML.replace(login.full_match, "<div login=''></div>");
      }
    };
    findLogin = function() {
      var code, content, full_match, matched;
      code = document.body.innerHTML;
      matched = LOGIN_REGEX.exec(code);
      if (matched) {
        full_match = matched[0];
        content = matched[3];
        login = {
          full_match: full_match,
          content: content
        };
      }
      return login;
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
      stepContent: stepContent,
      loginContent: loginContent
    };
  })();

  Compiler.hide();

  window.onload = function() {
    return Compiler.init();
  };

}).call(this);

},{}]},{},[1])