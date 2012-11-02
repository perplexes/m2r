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
      @push.send_string(msg = "1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,", ZMQ::NOBLOCK)
      assert_equal msg, connection.receive
    end

    def test_exception_when_receiving
      request_socket = mock(:recv_string => -1)
      connection = Connection.new request_socket, nil
      assert_raises(Connection::Error) { connection.receive }
    end

    def test_exception_when_deliverying
      response_socket = mock(:send_string => -1)
      connection = Connection.new nil, response_socket
      assert_raises(Connection::Error) { connection.deliver('uuid', ['connection_ids'], 'data') }
    end

    def test_exception_when_replying
      response_socket = mock(:send_string => -1)
      connection = Connection.new nil, response_socket
      assert_raises(Connection::Error) { connection.reply( Struct.new(:sender, :conn_id).new('sender', 'conn_id') , 'data' ) }
    end

  end
end
