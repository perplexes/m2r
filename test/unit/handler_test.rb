require 'test_helper'

module M2R
  class HandlerTest < MiniTest::Unit::TestCase

    def test_lifecycle_for_disconnect
      connection = stub(:receive => "", :close => nil)
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => disconnect_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :disconnect, :all], h.called_methods
    end

    def test_lifecycle_for_upload_start
      connection = stub(:receive => "", :close => nil)
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => upload_start_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :start, :all], h.called_methods
    end

    def test_lifecycle_for_upload_done
      connection = stub(:receive => "", :reply => nil, :close => nil)
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => upload_done_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :done, :process, :after, :reply, :all], h.called_methods
    end

    def test_lifecycle_for_exception_when_getting_request
      connection = stub(:close => nil)
      connection.stubs(:receive).raises(StandardError)
      connection.stubs(:connection).returns(connection)
      h = TestHandler.new(connection, nil)
      h.listen
      assert_equal [:wait, :error], h.called_methods
    end

    def test_lifecycle_for_exception_when_processing
      connection = stub(:receive => "", :reply => nil, :close => nil)
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => request)
      h = TestHandler.new(connection, parser)
      h.extend(Module.new(){
        def process(request)
          super
          raise StandardError
        end
      })
      h.listen
      assert_equal [:wait, :request, :process, :all, :error], h.called_methods
    end

    def test_signal_when_receive
      e = Connection::Error.new.tap{|x| x.errno = 4}
      connection = stub(:reply => nil, :close => nil)
      connection.stubs(:connection).returns(connection)
      connection.expects(:receive).raises(e).then.returns("").twice
      parser = stub(:parse => request)
      h = TestHandler.new(connection, parser)
      h.extend(Module.new(){
        def on_wait
          if @called_methods.size > 2
            stop
            return
          end
          @called_methods << :wait
        end
      })
      h.listen
      assert_equal [:wait, :interrupted, :wait, :request, :process, :after, :reply, :all], h.called_methods
    end

    def test_connection_closed
      connection = mock(:close => nil)
      connection.expects(:connection).returns(connection)
      h = TestHandler.new(connection, nil)
      h.stop
      h.listen
    end


    private


    def disconnect_request
      Request.new("sender", "conn_id", "/path", Headers.new({}), Headers.new({"METHOD" => "JSON"}), '{"type":"disconnect"}')
    end

    def upload_start_request
      Request.new("sender", "conn_id", "/path", Headers.new({}), Headers.new({"x-mongrel2-upload-start" => "/tmp/file"}), '')
    end

    def upload_done_request
      Request.new("sender", "conn_id", "/path", Headers.new({}), Headers.new({"x-mongrel2-upload-start" => "/tmp/file", "x-mongrel2-upload-done" => "/tmp/file"}), '')
    end

    def request
      Request.new("sender", "conn_id", "/path", Headers.new({}), Headers.new({}), '')
    end

  end
end
