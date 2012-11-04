require 'test_helper'

module M2R
  class TestRequest < MiniTest::Unit::TestCase
    def test_parse
      data = %q[FAKESENDER 0 / 97:{"PATH":"/","host":"default","METHOD":"HEAD","VERSION":"HTTP/1.1","URI":"/","URL_SCHEME":"https"},0:,]
      request = Request.parse(data)

      assert_equal "/", request.path
      assert_equal "default", request.headers['Host']
      assert_equal "HEAD", request.method
      assert_equal nil, request.query
      assert_equal nil, request.pattern
      assert_equal "https", request.scheme
      assert_equal false, request.close?
    end

    def test_scheme
      data = %q[FAKESENDER 0 / 96:{"PATH":"/","host":"default","METHOD":"HEAD","VERSION":"HTTP/1.1","URI":"/","URL_SCHEME":"http"},0:,]
      request = Request.parse(data)
      assert_equal "http", request.scheme
    end

    def test_http_scheme_in_mongrel17
      data = %q[FAKESENDER 0 / 76:{"PATH":"/","host":"default","METHOD":"HEAD","VERSION":"HTTP/1.1","URI":"/"},0:,]
      request = Request.parse(data)
      assert_equal "http", request.scheme
    end

    def test_https_scheme_in_mongrel17_set_via_env
      ENV['HTTPS']='true'
      data = %q[FAKESENDER 0 / 76:{"PATH":"/","host":"default","METHOD":"HEAD","VERSION":"HTTP/1.1","URI":"/"},0:,]
      request = Request.parse(data)
      assert_equal "https", request.scheme
    ensure
      ENV.delete('HTTPS')
    end
  end
end
