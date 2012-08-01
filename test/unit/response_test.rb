require 'test_helper'

module M2R
  class ResponseTest < MiniTest::Unit::TestCase
    def test_response_with_nil_body
      ok = Response.new(200, {"Transfer-Encoding" => "chunked"}, nil)
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_empty_body
      ok = Response.new(200, {"Transfer-Encoding" => "chunked"}, "")
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_no_body
      ok = Response.new(200, {"Transfer-Encoding" => "chunked"})
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_content_length
      ok = Response.new(200, {}, 'data')
      ok.extend Response::ContentLength
      http = "HTTP/1.1 200 OK\r\nContent-Length: 4\r\n\r\ndata"
      assert_equal http, ok.to_s
    end
  end
end
