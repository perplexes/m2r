require 'test_helper'
require 'securerandom'

module M2R
  class ConnectionFactoryTest < MiniTest::Unit::TestCase
    def test_factory
      sender_id = "sid"
      request_addr = "req"
      response_addr = "req"

      pull    = stub(:pull)
      pub     = stub(:pub)
      context = stub(:context)

      context.expects(:socket).with(ZMQ::PULL).returns(pull)
      context.expects(:socket).with(ZMQ::PUB).returns(pub)

      pull.expects(:connect).with(request_addr)

      pub.expects(:connect).with(response_addr)
      pub.expects(:setsockopt).with(ZMQ::IDENTITY, sender_id)

      Connection.expects(:new).with(pull, pub)
      cf = ConnectionFactory.new sender_id, request_addr, response_addr, context
      cf.connection
    end
  end
end
