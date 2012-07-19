require 'test_helper'

class HandlerTest < MiniTest::Unit::TestCase
  def test_lifecycle_for_disconnect
    connection = stub(:receive => disconnect_request)
    h = TestHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :disconnect], h.called_methods
  end

  def test_lifecycle_for_upload_start
    connection = stub(:receive => upload_start_request)
    h = TestHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :start], h.called_methods
  end

  def test_lifecycle_for_upload_done
    connection = stub(:receive => upload_done_request, :reply => nil)
    h = TestHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :done, :process, :after, :reply], h.called_methods
  end

  def disconnect_request
    M2R::Request.new("sender", "conn_id", "/path", M2R::Headers.new({"METHOD" => "JSON"}), '{"type":"disconnect"}')
  end

  def upload_start_request
    M2R::Request.new("sender", "conn_id", "/path", M2R::Headers.new({"x-mongrel2-upload-start" => "/tmp/file"}), '')
  end

  def upload_done_request
    M2R::Request.new("sender", "conn_id", "/path", M2R::Headers.new({"x-mongrel2-upload-start" => "/tmp/file", "x-mongrel2-upload-done" => "/tmp/file"}), '')
  end
end
