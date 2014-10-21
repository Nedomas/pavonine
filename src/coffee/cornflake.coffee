# Godfather = require 'godfather'

Cornflake = (->
  # _ = require('lodash')

  step_results = {}

  init = ->
    console.log('Here and now')
    Godfather.API_URL = 'http://10.30.0.1:3000'
    state(1)

  state = (i) ->
    interpolate(i)
    CornflakeSteps.changeStep(i)

  interpolate = (i) ->
    state_part = CornflakeSteps.element(i)
    state_html = $('<div>').append(state_part.clone()).html()
    data = step_results[i - 1]

    result = state_html

    _.each keywords(state_html), (keyword) ->
      value = data[keyword] or throw "No value for #{keyword} in #{data}"
      result = result.replace('#{' + keyword + '}', value)

    state_part.replaceWith(result)

  keywords = (text) ->
    all = text.match(/#{[a-z0-9]+}/)
    _.map all, (keyword) ->
      keyword.replace('#{', '').replace('}', '')

  bindStep = (model, attributes, action) ->
    $(action.element).click(_.partial(act, model, attributes, action))

  act = (model, attributes, action, e) ->
    e.preventDefault()

    connection = new Godfather("#{model}s")
    attribute_values = _.inject(attributes, (result, element, name) ->
      result[name] = element.val()
      result
    , {})

    connection[action.name](attribute_values).then (record) ->
      step_number = 1
      step_results[step_number] = record
      state(step_number + 1)

  return {
    init: init
    bindStep: bindStep
  }
)()

CornflakeSteps = (->
  # $ = require('jquery')
  React = require('react')
  HTMLtoJSX = require('htmltojsx')
  react_tools = require('react-tools')

  changeStep = (i) ->
    initializers()
    window.email = 'tsup'
    hideAllBut(i)
    binding(i)
    component = jQueryToReactComponent(element(1))
    React.renderComponent(component(),
      document.getElementById('bind-here'))

  coreMixin = ->
    getInitialState: ->
      value: 'Hello!'
    getDefaultProps: ->
      email: 'hater'
    handleChange: (e) ->
      @setState
        value: e.target.value
      console.log('changed')
    handleClick: (e) ->
      console.log('yooaaaaaaaaaaaaaaaaaaaaaa')
      e.preventDefault()
      debugger
      # @setState({liked: !this.state.liked})
    componentDidMount: ->
      console.log('yoo')
      # debugger

  jQueryToReactComponent = (element) ->
    html = toXHTML(outerHTML(element))
    klass_name = "Cornflake#{random()}"

    jsx = toJSX(klass_name, html)
    toComponent(klass_name, jsx)

  toComponent = (klass_name, jsx) ->
    CoreMixin = coreMixin()
    component_code = react_tools.transform(jsx)
    eval(component_code)
    eval(klass_name)

  toJSX = (klass_name, html) ->
    converter = new HTMLtoJSX
      createClass: true
      outputClassName: klass_name

    jsx_code = "/** @jsx React.DOM */\n" + converter.convert(html)
    jsx_code = jsx_code.splice(64, 0, 'mixins: [CoreMixin],\n  ')
    jsx_code = jsx_code.replace(/"{/g, '{').replace(/}"/g, '}')
    jsx_code = jsx_code.replace(/onchange/g, 'onChange').replace(/onclick/g, 'onClick')

  random = ->
    min = 1
    max = 10000
    Math.floor(Math.random() * (max - min + 1)) + min

  initializers = ->
    String::splice = (idx, rem, s) ->
      (@slice(0, idx) + s + @slice(idx + Math.abs(rem)))

  toXHTML = (input) ->
    without_spaces = input.replace('\n', '').replace(/\s{2,}/g, '')
    doc = new DOMParser().parseFromString(without_spaces, 'text/html')
    result = new XMLSerializer().serializeToString(doc)
    /<body>(.*)<\/body>/im.exec(result)
    RegExp.$1

  binding = (i) ->
    model = element(i).data('model')
    attributeElements = element(i).find('*[data-attribute]')
    attributes = _.inject(attributeElements, (result, element) ->
      result[$(element).data('attribute')] = $(element)
      result
    , {})

    actionElement = element(i).find('*[data-action]').first()
    action = { element: actionElement, name: $(actionElement).data('action') }

    Cornflake.bindStep(model, attributes, action)

  hideAllBut = (dont_hide_i) ->
    _.each idx(), (element, i) ->
      if parseInt(i) == dont_hide_i
        element.show()
      else
        element.hide()

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
    changeStep: changeStep
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
