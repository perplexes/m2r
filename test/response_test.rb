require 'test_helper'

class ResponseTest < MiniTest::Unit::TestCase
  def test_response_with_nil_body
    ok = M2R::Response.new(200, {"Transfer-Encoding" => "chunked"}, nil)
    http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
    assert_equal http, ok.to_s
  end

  def test_response_with_empty_body
    ok = M2R::Response.new(200, {"Transfer-Encoding" => "chunked"}, "")
    http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
    assert_equal http, ok.to_s
  end

  def test_response_with_no_body
    ok = M2R::Response.new(200, {"Transfer-Encoding" => "chunked"})
    http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
    assert_equal http, ok.to_s
  end

  def test_response_with_content_length
    ok = M2R::Response.new(200, {}, 'data')
    ok.extend M2R::Response::ContentLength
    http = "HTTP/1.1 200 OK\r\nContent-Length: 4\r\n\r\ndata"
    assert_equal http, ok.to_s
  end
end

