require 'test_helper'

class ResponseTest < MiniTest::Unit::TestCase
  def test_ok_response
    ok = M2R::Response::Ok.new("body")
    http = "HTTP/1.1 200 OK\r\nContent-Length: 4\r\n\r\nbody"
    assert_equal http, ok.to_s
  end

  def test_response
    ok = M2R::Response.new(200, {"Transfer-Encoding" => "chunked"}, nil)
    http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
    assert_equal http, ok.to_s
  end
end

