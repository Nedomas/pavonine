var Cornflake, CornflakeSteps;

Cornflake = (function() {
  var act, bindStep, init, interpolate, keywords, state, step_results;
  step_results = {};
  init = function() {
    console.log('Here and now');
    Godfather.API_URL = 'http://10.30.0.1:3000';
    return state(1);
  };
  state = function(i) {
    interpolate(i);
    return CornflakeSteps.changeStep(i);
  };
  interpolate = function(i) {
    var data, result, state_html, state_part;
    state_part = CornflakeSteps.element(i);
    state_html = $('<div>').append(state_part.clone()).html();
    data = step_results[i - 1];
    result = state_html;
    _.each(keywords(state_html), function(keyword) {
      var value;
      value = data[keyword] || (function() {
        throw "No value for " + keyword + " in " + data;
      })();
      return result = result.replace('#{' + keyword + '}', value);
    });
    return state_part.replaceWith(result);
  };
  keywords = function(text) {
    var all;
    all = text.match(/#{[a-z0-9]+}/);
    return _.map(all, function(keyword) {
      return keyword.replace('#{', '').replace('}', '');
    });
  };
  bindStep = function(model, attributes, action) {
    return $(action.element).click(_.partial(act, model, attributes, action));
  };
  act = function(model, attributes, action, e) {
    var attribute_values, connection;
    e.preventDefault();
    connection = new Godfather("" + model + "s");
    attribute_values = _.inject(attributes, function(result, element, name) {
      result[name] = element.val();
      return result;
    }, {});
    return connection[action.name](attribute_values).then(function(record) {
      var step_number;
      step_number = 1;
      step_results[step_number] = record;
      return state(step_number + 1);
    });
  };
  return {
    init: init,
    bindStep: bindStep
  };
})();

CornflakeSteps = (function() {
  var binding, changeStep, element, elements, hideAllBut, idx;
  changeStep = function(i) {
    hideAllBut(i);
    return binding(i);
  };
  binding = function(i) {
    var action, actionElement, attributeElements, attributes, model;
    model = element(i).data('model');
    attributeElements = element(i).find('*[data-attribute]');
    attributes = _.inject(attributeElements, function(result, element) {
      result[$(element).data('attribute')] = $(element);
      return result;
    }, {});
    actionElement = element(i).find('*[data-action]').first();
    action = {
      element: actionElement,
      name: $(actionElement).data('action')
    };
    return Cornflake.bindStep(model, attributes, action);
  };
  hideAllBut = function(dont_hide_i) {
    return _.each(idx(), function(element, i) {
      if (parseInt(i) === dont_hide_i) {
        return element.show();
      } else {
        return element.hide();
      }
    });
  };
  element = function(i) {
    return idx()[i];
  };
  idx = function() {
    return _.inject(elements(), function(result, element) {
      var step;
      step = $(element).data('step') || 1;
      result[step] = $(element);
      return result;
    }, {});
  };
  elements = function() {
    return $('*[data-model], *[data-step]');
  };
  return {
    changeStep: changeStep,
    element: element
  };
})();

window.onload = function() {
  return Cornflake.init();
};
