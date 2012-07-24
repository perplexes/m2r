require 'test_helper'
require 'm2r/rack_handler'

class HelloWorld
  def call(env)
    return [200, {'Content-Type' => 'text/plain'}, ["Hello world!"]]
  end
end

module M2R
  class RackHandlerTest < MiniTest::Unit::TestCase
    def test_discoverability
      handler = ::Rack::Handler.get(:mongrel2)
      assert_equal ::Rack::Handler::Mongrel2, handler

      handler = ::Rack::Handler.get('Mongrel2')
      assert_equal ::Rack::Handler::Mongrel2, handler
    end

    def test_options
      require 'rack/handler/mongrel2'
      handler = ::Rack::Handler::Mongrel2
      options = {
        :recv_addr => 'tcp://1.2.3.4:1234',
        :send_addr => 'tcp://1.2.3.4:4321',
        :sender_id => SecureRandom.uuid
      }
      Connection.expects(:for).with(options[:sender_id], options[:recv_addr], options[:send_addr])
      RackHandler.any_instance.stubs(:stop? => true)
      handler.run(HelloWorld.new, options)
    end

    def test_lint_rack_adapter
      connection = stub
      handler    = RackHandler.new(app, connection)
      response   = handler.process(root_request)

      assert_equal "Hello world!", response.body
      assert_equal 200, response.status
    end

    def root_request
      data = %q("1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 96:{"PATH":"/","host":"127.0.0.1:6767","PATTERN":"/","METHOD":"GET","VERSION":"HTTP/1.1","URI":"/"},0:,)
      Request.parse(data)
    end

    def app
      Rack::Lint.new(HelloWorld.new)
    end
  end
end
