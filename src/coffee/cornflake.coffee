# Godfather = require 'godfather'

Cornflake = (->
  # _ = require('lodash')

  init = ->
    console.log('Here and now')
    initializers()
    CornflakeUI.state(1)

  initializers = ->
    Godfather.API_URL = 'http://10.30.0.1:3000'
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))

  act = (action, e, attributes) ->
    e.preventDefault()
    model_element = $(e.target).parent('*[data-model]')
    throw new Error 'No model specified' if _.isEmpty(model_element)
    model = model_element.data('model')

    connection = new Godfather("#{model}s")
    connection[action](attributes).then (resp) ->
      record = if _.isObject(resp) then resp else null
      CornflakeUI.nextState(record)

  return {
    init: init
    act: act
  }
)()

CornflakeUI = (->
  # $ = require('jquery')
  React = require('react')
  HTMLtoJSX = require('htmltojsx')
  react_tools = require('react-tools')
  step_results = { 0: {} }
  current_state = 1

  previousState = (results) ->
    step_results[current_state] = results
    state(current_state - 1)

  nextState = (results) ->
    step_results[current_state] = results
    state(current_state + 1)

  state = (i) ->
    current_state = i
    hideAllBut(i)
    klass_name = "cornflake#{random()}"
    component = jQueryToReactComponent(klass_name, element(i))
    element(i).before("<div id='#{klass_name}'>")
    element(i).hide()
    React.renderComponent(component(),
      document.getElementById(klass_name))

  coreMixin = ->
    getInitialState: ->
      step_results[current_state - 1]
    onChange: (attribute, e) ->
      attribute_hash = {}
      attribute_hash[attribute] = e.target.value
      @setState(attribute_hash)
    create: (e) ->
      Cornflake.act('create', e, @state)
    update: (e) ->
      Cornflake.act('update', e, @state)
    destroy: (e) ->
      Cornflake.act('destroy', e, @state)
    previous: (e) ->
      e.preventDefault()
      previousState(@state)
    next: (e) ->
      e.preventDefault()
      nextState(@state)

  jQueryToReactComponent = (klass_name, element) ->
    html = toXHTML(outerHTML(element))
    jsx = toJSX(klass_name, html)
    toComponent(klass_name, jsx)

  toComponent = (klass_name, jsx) ->
    CoreMixin = coreMixin()
    component_code = react_tools.transform(jsx)
    eval(component_code)
    eval(klass_name)

  toJSX = (klass_name, html) ->
    # jsx_code = wrapInJSX(klass_name, html)

    converter = new HTMLtoJSX
      createClass: true
      outputClassName: klass_name

    jsx_code = "/** @jsx React.DOM */\n" + converter.convert(html)
    render_index = jsx_code.match('render').index
    jsx_code = jsx_code.splice(render_index, 0, 'mixins: [CoreMixin],\n  ')

    jsx_code = jsx_code.replace(/"{/g, '{').replace(/}"/g, '}')
    jsx_code = jsx_code.replace(/onchange/g, 'onChange').replace(/onclick/g, 'onClick')
    jsx_code = replaceToBindings(jsx_code)
    jsx_code = replaceToActions(jsx_code)
    jsx_code = replaceToState(jsx_code)
    jsx_code

  wrapInJSX = (klass_name, html) ->
    result =
      l('/** @jsx React.DOM */') +
      l("var #{klass_name} = React.createClass({") +
      l('  mixins: [CoreMixin],') +
      l('  render: function() {') +
      l('    return (') +
      l("      #{html}") +
      l('    );') +
      l('  }') +
      l('});')

  l = (code) ->
    "#{code}\n"

  replaceToActions = (jsx_code) ->
    actions = ['create', 'update', 'destroy', 'previous', 'next']
    re = /{([a-z]*)}/gi
    result = jsx_code

    loop
      matched = re.exec(result)

      if matched
        # {create} => {this.create}
        attribute = matched[1]

        if _.include(actions, attribute)
          length = matched[0].length
          react_tag = "{this.#{attribute}}"
          result = result.splice(matched.index, length, react_tag)
      else
        break

    result

  replaceToState = (jsx_code) ->
    re = /{([a-zA-Z]*)}/gi
    result = jsx_code

    loop
      matched = re.exec(result)

      if matched
        # {email} => {this.state.email}
        attribute = matched[1]
        length = matched[0].length
        react_tag = "{this.state.#{attribute}}"
        result = result.splice(matched.index, length, react_tag)
      else
        break

    result

  replaceToBindings = (jsx_code) ->
    re = /value={(.+?)}/gi
    result = jsx_code

    loop
      matched = re.exec(result)

      if matched
        # value={email} => value={email} onChange={_.partial(this.onChange)}
        attribute = matched[1]
        length = matched[0].length
        new_line = " onChange={_.partial(this.onChange, '#{attribute}')}"
        result = result.splice(matched.index + length, 0, new_line)
      else
        break

    result

  random = ->
    min = 1
    max = 10000
    Math.floor(Math.random() * (max - min + 1)) + min

  toXHTML = (input) ->
    without_spaces = input.replace('\n', '').replace(/\s{2,}/g, '')
    doc = new DOMParser().parseFromString(without_spaces, 'text/html')
    result = new XMLSerializer().serializeToString(doc)
    /<body>(.*)<\/body>/im.exec(result)
    RegExp.$1

  hideAllBut = (dont_hide_i) ->
    _.each $('*[data-model], *[data-step]'), (element) ->
      jelement = $(element)
      step = jelement.data('step') or 1

      if parseInt(step) == dont_hide_i
        jelement.show()
      else
        if jelement.data('reactid')
          jelement.remove()
        else
          jelement.hide()

  element = (i) ->
    idx()[i]

  outerHTML = (element) ->
    $('<div>').append(element.clone()).html()

  idx = ->
    _.inject(elements(), (result, element) ->
      step = $(element).data('step') or 1
      result[step] = $(element)
      result
    , {})

  elements = ->
    $('*[data-model], *[data-step]')

  return {
    nextState: nextState
    state: state
    element: element
  }
)()

# You can specify scope for the connection.
#
# ```coffeescript
#   User = new Godfather '/users', city: 'New York'
#
#   User.where(name: 'John').then (users) ->
#     alert 'You are a New Yorker called John'
#
#   User.create(name: 'Peter').then (new_user) ->
#     # I am from New York
#     alert "I am from #{new_user.city}"
# ```
# _ = require('lodash')

Godfather = (endpoint, scope, options) ->
  @endpoint = endpoint
  @scope = scope or {}
  @options = options or {}
  @extra_find_scopes = @options.extra_find_scopes or []
  @records = []
  @seeds = []
  @properties = []
  return

# ## Configs

# Functions ``request`` and ``promise`` are overritable
Godfather.API_URL = ""

# Should do a POST request and return a ``promise``
Godfather::request = (action, params) ->
  $.post @url(action), @data(params), 'json'

# Should return a ``promise`` which resolves with ``result``
Godfather::promise = (result) ->
  deferred = $.Deferred()
  deferred.resolve result
  deferred.promise()

Godfather::where = (params) ->
  _this = @

  @request('where', params).then (records) ->
    records = records.concat(_this.seeds)
    computed_records = _.map(records, (record) ->
      _this.withComputedProps record
    )
    _this.properties = _.keys(records[0])
    _this.records = _.sortBy(computed_records, 'id')
    _this.promise _this.records

# Return a single record by ``id``
#
# ```coffeescript
# User.find(15).then (user) ->
#   alert "Yo, #{user.name}"
# ```
Godfather::find = (id) ->
  _this = @

  @where(id: id).then ->
    _this.promise _this.take(id)

# Return a single record by ``params``
#
# ```coffeescript
# User.findBy(name: 'John', city: 'New York').then (user) ->
#   alert "I'm John from New York"
# ```
Godfather::findBy = (params) ->
  _this = @

  @where(params).then (resp) ->
    _this.promise _.first(_.values(resp))

Godfather::create = (params) ->
  @requestAndRefresh 'create', params

# Specify ``id`` when updating or destroying the record.
#
# ```coffeescript
#   User = new Godfather '/users'
#
#   User.update(id: 15, name: 'Saint John').then (updated_user) ->
#     alert updated_user
#
#   User.destroy(id: 15).then (resp) ->
#     alert resp.success
# ```
Godfather::update = (params) ->
  @requestAndRefresh 'update', params

Godfather::destroy = (params) ->
  @requestAndRefresh 'destroy', params

# Just take already dowloaded records
Godfather::take = (id) ->
  _.detect @records, (record) ->
    parseInt(record.id) == parseInt(id)

Godfather::takeAll = ->
  @records

# F.e. Have default records
Godfather::injectSeedRecords = (records) ->
  @seeds = records

# Used with Angular.js ``$watch`` to sync model changes to backend
Godfather::syncDiff = (new_records, old_records) ->
  _this = this

  dirty_records = _.select(new_records, (new_record) ->
    record_with_same_id = _.detect(old_records, (old_record) ->
      new_record.id is old_record.id
    )
    JSON.stringify(_.pick(record_with_same_id, _this.properties)) isnt
      JSON.stringify(_.pick(new_record, _this.properties))
  )
  _.each dirty_records, (record) ->
    _this.update record

Godfather::requestAndRefresh = (action, params) ->
  _this = @

  # backend responds with { success: true, id: record.id }
  @request(action, params).then (resp) ->
    throw new Error 'Error in the backend' unless resp?.success

    _this.where().then ->
      if resp.id
        _this.promise _this.take(resp.id)
      else
        _this.promise resp.success

Godfather::withComputedProps = (record) ->
  if @computed
    _.extend record, @computed(record)
  else
    record

Godfather::url = (action) ->
  "#{Godfather.API_URL}/#{@endpoint}/#{action}"

Godfather::data = (params) ->
  scope: JSON.stringify(@scope)
  extra_find_scopes: JSON.stringify(@extra_find_scopes)
  data: JSON.stringify(params)
window.onload = ->
  Cornflake.init()
