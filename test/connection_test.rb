require 'test_helper'

class ConnectionTest < MiniTest::Unit::TestCase
  def test_receive_message
    request_addr  = "inproc://requests"
    response_addr = "inproc://responses"

    push = M2R.zmq_context.socket(ZMQ::PUSH)
    assert_equal 0, push.bind(request_addr), "Could not bind push socket in tests"

    sub = M2R.zmq_context.socket(ZMQ::SUB)
    assert_equal 0, sub.bind(response_addr), "Could not bind sub socket in tests"

    connection = M2R::Connection.for("a65c2d89-96ee-4bc9-971e-59b38ae24645", request_addr, response_addr)

    push.send_string("1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,", ZMQ::NOBLOCK)

    assert_instance_of M2R::Request, connection.receive
  end
end
