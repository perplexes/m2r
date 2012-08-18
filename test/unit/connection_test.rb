require 'test_helper'
require 'securerandom'

module M2R
  class ConnectionTest < MiniTest::Unit::TestCase

    def setup
      @request_addr  = "inproc://#{SecureRandom.hex}"
      @response_addr = "inproc://#{SecureRandom.hex}"

      @push = M2R.zmq_context.socket(ZMQ::PUSH)
      assert_equal 0, @push.bind(@request_addr), "Could not bind push socket in tests"

      @sub = M2R.zmq_context.socket(ZMQ::SUB)
      assert_equal 0, @sub.bind(@response_addr), "Could not bind sub socket in tests"


      @request_socket = M2R.zmq_context.socket(ZMQ::PULL)
      @request_socket.connect(@request_addr)

      @response_socket = M2R.zmq_context.socket(ZMQ::PUB)
      @response_socket.connect(@response_addr)
      @response_socket.setsockopt(ZMQ::IDENTITY, @sender_id = SecureRandom.uuid)
    end

    def teardown
      @request_socket.close  if @request_socket
      @response_socket.close if @response_socket
      @push.close            if @push
      @sub.close             if @sub
    end

    def test_receive_message
      connection = Connection.new(@request_socket, @response_socket)
      @push.send_string("1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,", ZMQ::NOBLOCK)
      assert_instance_of Request, connection.receive
    end

    def test_different_parser
      msg = "1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,"
      parser = stub(:parser)
      parser.expects(:parse).with(msg).returns(request = Object.new)
      connection = Connection.new(@request_socket, @response_socket, parser)
      @push.send_string(msg = "1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,", ZMQ::NOBLOCK)
      assert_equal request, connection.receive
    end

  end
end
