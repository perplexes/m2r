require 'test_helper'
require 'rack'

class RackHandlerTest < MiniTest::Unit::TestCase
  def test_discoverability
    handler = Rack::Handler.get(:mongrel2)
    assert_equal Rack::Handler::Mongrel2, handler

    handler = Rack::Handler.get('Mongrel2')
    assert_equal Rack::Handler::Mongrel2, handler
  end
end
