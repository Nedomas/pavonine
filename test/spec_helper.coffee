jsdom = require 'jsdom'

# move into beforeEach and flip global.window.close on to improve
# cleaning of environment during each test and prevent memory leaks
document = jsdom.jsdom('<html><body></body></html>', jsdom.level(1, 'core'))

beforeEach ->
  @document = document
  global.document = @document
  global.window = @document.parentWindow

afterEach ->
