require 'test_helper'

module M2R
  class MultithreadHandlerTest < MiniTest::Unit::TestCase
    SLEEP_TIME  = 3
    MARGIN_TIME = 1
    WAIT_TIME   = 1

    class ThreadTestHandler < TestHandler
      def process(request)
        sleep(SLEEP_TIME)
        super
        return Thread.current.object_id.to_s
      end
    end

    class TestSinglethreadHandlerFactory
      def initialize(connection_factory, parser)
        @connection_factory = connection_factory
        @parser             = parser
      end

      def new
        ThreadTestHandler.new(@connection_factory, @parser)
      end
    end

    def setup
      @request_addr  = "inproc://#{SecureRandom.hex}"
      @response_addr = "inproc://#{SecureRandom.hex}"

      @push = M2R.zmq_context.socket(ZMQ::PUSH)
      assert_equal 0, @push.bind(@request_addr), "Could not bind push socket in tests"

      @sub = M2R.zmq_context.socket(ZMQ::SUB)
      assert_equal 0, @sub.bind(@response_addr), "Could not bind sub socket in tests"
      @sub.setsockopt(ZMQ::SUBSCRIBE, "")
    end

    def teardown
      @push.close            if @push
      @sub.close             if @sub
    end

    def test_threads_are_processing_request_simultaneously
      cf  = ConnectionFactory.new(ConnectionFactory::Options.new(nil, @request_addr, @response_addr))
      par = Parser.new
      mth = MultithreadHandler.new(TestSinglethreadHandlerFactory.new(cf, par))
      mth.listen
      sleep(WAIT_TIME)

      start = Time.now
      8.times do |i|
        @push.send_string(msg = "1c5fd481-1121-49d8-a706-69127975db1a ebb407b2-49aa-48a5-9f96-9db12105148#{i} / 2:{},1:#{i},", ZMQ::NOBLOCK)
      end
      responses = 16.times.map do
        @sub.recv_string(msg = "")
        msg
      end
      finish = Time.now

      mth.threads.each do |t|
        t.join
      end

      blob = responses.join("\n")
      mth.threads.each do |t|
        assert blob.include?(", #{t.object_id}")
      end

      delta  = finish - start
      assert_in_delta(SLEEP_TIME, delta, MARGIN_TIME)
    end
  end
end
