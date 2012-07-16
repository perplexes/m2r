require 'test_helper'
require 'm2r/adapter/rack'

class HelloWorld
  def call(env)
    return [200, {'Content-Type' => 'text/plain'}, ["Hello world!"]]
  end
end

class RackAdapterTest < MiniTest::Unit::TestCase
  def test_lint_rack_adapter
    connection = stub
    adapter    = M2R::Adapter::Rack.new(app, connection)
    response   = adapter.process(root_request)

    assert_equal "Hello world!", response.body
    assert_equal 200, response.status
  end

  def root_request
    data = %q("1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 96:{"PATH":"/","host":"127.0.0.1:6767","PATTERN":"/","METHOD":"GET","VERSION":"HTTP/1.1","URI":"/"},0:,)
    M2R::Request.parse(data)
  end

  def app
    Rack::Lint.new(HelloWorld.new)
  end
end
