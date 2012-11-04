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

    def test_response_with_header
      ok = Response.new.body('data').header('X-Man', 'Wolverine')
      ok.extend Response::ContentLength
      http = "HTTP/1.1 200 OK\r\nx-man: Wolverine\r\ncontent-length: 4\r\n\r\ndata"
      assert_equal http, ok.to_s
    end

    def test_response_with_old_version
      ok = Response.new.http_version('HTTP/1.0').body('data')
      ok.extend Response::ContentLength
      http = "HTTP/1.0 200 OK\r\ncontent-length: 4\r\n\r\ndata"
      assert_equal http, ok.to_s
    end

    def test_getters
      ok = Response.new.http_version(v = 'HTTP/1.0').status(s = 300).headers({'X-Man' => xman = 'Summers'}).header("X-Angel", angel = "Warren").body(data = 'data')
      assert_equal v,     ok.http_version
      assert_equal s,     ok.status
      assert_equal xman,  ok.header("X-Man")
      assert_equal angel, ok.header("X-Angel")
      assert_equal data , ok.body
      assert_equal 2,     ok.headers.size
    end

    def test_default_close
      ok = Response.new
      refute ok.close?
    end

    def test_http10_close
      ok = Response.new.http_version('HTTP/1.0')
      assert ok.close?
    end

    def test_header_close
      ok = Response.new.header('Connection', 'close')
      assert ok.close?
    end

    def test_response_to_http10
      ok = Response.new
      ok.extend(Response::ToRequest)
      ok.to(mock(http_version: 'HTTP/1.0', close?:true))
      assert_equal 'HTTP/1.0', ok.http_version
      assert_equal 'close', ok.header('Connection')
    end

    def test_response_to_http11
      ok = Response.new
      ok.extend(Response::ToRequest)
      ok.to(mock(http_version: 'HTTP/1.1', close?:false))
      assert_equal 'HTTP/1.1', ok.http_version
      assert_equal nil, ok.header('Connection')
    end
  end
end
