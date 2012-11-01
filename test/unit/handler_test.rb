require 'test_helper'

module M2R
  class HandlerTest < MiniTest::Unit::TestCase

    def test_lifecycle_for_disconnect
      connection = stub(:receive => "")
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => disconnect_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :disconnect, :all], h.called_methods
    end

    def test_lifecycle_for_upload_start
      connection = stub(:receive => "")
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => upload_start_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :start, :all], h.called_methods
    end

    def test_lifecycle_for_upload_done
      connection = stub(:receive => "", :reply => nil)
      connection.stubs(:connection).returns(connection)
      parser = stub(:parse => upload_done_request)
      h = TestHandler.new(connection, parser)
      h.listen
      assert_equal [:wait, :request, :done, :process, :after, :reply, :all], h.called_methods
    end


    private


    def disconnect_request
      Request.new("sender", "conn_id", "/path", Headers.new({"METHOD" => "JSON"}), '{"type":"disconnect"}')
    end

    def upload_start_request
      Request.new("sender", "conn_id", "/path", Headers.new({"x-mongrel2-upload-start" => "/tmp/file"}), '')
    end

    def upload_done_request
      Request.new("sender", "conn_id", "/path", Headers.new({"x-mongrel2-upload-start" => "/tmp/file", "x-mongrel2-upload-done" => "/tmp/file"}), '')
    end

  end
end
