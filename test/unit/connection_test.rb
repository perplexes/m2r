require 'test_helper'
require 'securerandom'

module M2R
  class ConnectionTest < MiniTest::Unit::TestCase

    def setup
      @request_addr  = "inproc://#{SecureRandom.hex}"
      @response_addr = "inproc://#{SecureRandom.hex}"

      @push = M2R.zmq_context.socket(ZMQ::PUSH)
      assert_equal 0, @push.bind(@request_addr), "Could not bind push socket in tests"

      @request_socket = M2R.zmq_context.socket(ZMQ::PULL)
      @request_socket.connect(@request_addr)

      @response_socket = M2R.zmq_context.socket(ZMQ::PUB)
      @response_socket.bind(@response_addr)
      @response_socket.setsockopt(ZMQ::IDENTITY, @sender_id = SecureRandom.uuid)

      @sub = M2R.zmq_context.socket(ZMQ::SUB)
      assert_equal 0, @sub.connect(@response_addr), "Could not connect sub socket in tests"
      @sub.setsockopt(ZMQ::SUBSCRIBE, "")
    end

    def teardown
      @request_socket.close  if @request_socket
      @response_socket.close if @response_socket
      @push.close            if @push
      @sub.close             if @sub
    end

    def test_receive_message
      connection = Connection.new(@request_socket, @response_socket)
      @push.send_string(msg = "1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db121051484 / 2:{},0:,", ZMQ::NonBlocking)
      assert_equal msg, connection.receive
    end

    def test_deliver_message
      connection = Connection.new(@request_socket, @response_socket)
      connection.deliver('uuid', ['conn1', 'conn2'], 'ddaattaa')
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 11:conn1 conn2, ddaattaa", msg
    end

    def test_string_reply_non_close
      connection = Connection.new(@request_socket, @response_socket)
      connection.reply( stub(sender: 'uuid', conn_id: 'conn1', close?: false), 'ddaattaa')
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ddaattaa", msg
      assert_equal -1, @sub.recv_string(msg = "", ZMQ::NonBlocking)
    end

    def test_string_reply_close
      connection = Connection.new(@request_socket, @response_socket)
      connection.reply( stub(sender: 'uuid', conn_id: 'conn1', close?: true), 'ddaattaa')
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ddaattaa", msg
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ", msg
    end

    def test_response_reply_non_close
      connection = Connection.new(@request_socket, @response_socket)
      connection.reply( stub(sender: 'uuid', conn_id: 'conn1'), mock(to_s: 'ddaattaa', close?: false))
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ddaattaa", msg
      assert_equal -1, @sub.recv_string(msg = "", ZMQ::NonBlocking)
    end

    def test_response_reply_close
      connection = Connection.new(@request_socket, @response_socket)
      connection.reply( stub(sender: 'uuid', conn_id: 'conn1'), mock(to_s: 'ddaattaa', close?: true))
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ddaattaa", msg
      assert @sub.recv_string(msg = "") > 0
      assert_equal "uuid 5:conn1, ", msg
    end

    def test_exception_when_receiving
      request_socket = mock(:recv_string => -1)
      connection = Connection.new request_socket, nil
      assert_raises(Connection::Error) { connection.receive }
    end

    def test_exception_erron_when_receiving
      request_socket = mock(:recv_string => -1)
      ZMQ::Util.expects(:errno).at_least_once.returns(4)
      connection = Connection.new request_socket, nil
      begin
        connection.receive
        flunk "exception expected"
      rescue => er
        assert_equal 4, er.errno
        assert er.signal?
      end
    end

    def test_exception_when_deliverying
      ZMQ::Util.expects(:errno).at_least_once.returns(1)
      response_socket = mock(:send_string => -1)
      connection = Connection.new nil, response_socket
      assert_raises(Connection::Error) { connection.deliver('uuid', ['connection_ids'], 'data') }
    end

    def test_exception_signal_retry
      ZMQ::Util.expects(:errno).at_least_once.returns(4)
      response_socket = mock
      response_socket.expects(:send_string).times(3).returns(-1)
      connection = Connection.new nil, response_socket
      assert_raises(Connection::Error) { connection.deliver('uuid', ['connection_ids'], 'data') }
    end

    def test_exception_signal_retry_ok
      ZMQ::Util.expects(:errno).at_least_once.returns(4)
      response_socket = mock
      response_socket.expects(:send_string).twice.returns(-1).then.returns(0)
      connection = Connection.new nil, response_socket
      assert connection.deliver('uuid', ['connection_ids'], 'data').size > 0
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
