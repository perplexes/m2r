require 'test_helper'

module M2R
  class ResponseTest < MiniTest::Unit::TestCase
    def test_response_with_nil_body
      ok = Response.new.status(200).headers({"Transfer-Encoding" => "chunked"}).body(nil)
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_empty_body
      ok = Response.new.status(200).headers({"Transfer-Encoding" => "chunked"}).body("")
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_no_body
      ok = Response.new.status(200).headers({"Transfer-Encoding" => "chunked"})
      http = "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n"
      assert_equal http, ok.to_s
    end

    def test_response_with_content_length
      ok = Response.new.body('data')
      ok.extend Response::ContentLength
      http = "HTTP/1.1 200 OK\r\ncontent-length: 4\r\n\r\ndata"
      assert_equal http, ok.to_s
    end

    def test_response_with_old_version
      ok = Response.new.http_version('HTTP/1.0').body('data')
      ok.extend Response::ContentLength
      http = "HTTP/1.0 200 OK\r\ncontent-length: 4\r\n\r\ndata"
      assert_equal http, ok.to_s
    end
  end
end
