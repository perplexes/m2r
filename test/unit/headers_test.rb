require 'test_helper'

module M2R
  class HeadersTest < MiniTest::Unit::TestCase
    def test_case_insensitivity
      headers = Headers.new({"Content-Type" => "CT"})
      assert_equal "CT", headers['content-type']
      assert_equal "CT", headers['Content-Type']
      assert_equal "CT", headers['Content-type']
    end

    def test_underscore
      headers = Headers.new({"URL_SCHEME" => "https"})
      assert_equal "https", headers['url_scheme']
    end

    def test_symbols_as_keys
      headers = Headers.new({"type" => "Ty"})
      assert_equal "Ty", headers[:type]
    end

    def test_rackify
      headers = Headers.new({
        "Content-Type" => "CT",
        "type" => "Ty",
        "Accept-Charset" => "utf8",
        "cOnTenT-LeNgTh" => "123"
      })
      env = {"rack.version" => [1,1]}
      headers.rackify(env)
      assert_equal({
        "rack.version" => [1,1],
        "CONTENT_TYPE" => "CT",
        "HTTP_TYPE"    => "Ty",
        "HTTP_ACCEPT_CHARSET" => "utf8",
        "CONTENT_LENGTH" => "123"
      }, env)
    end

    def test_rackify_empty_headers
      headers = Headers.new({})
      env = {"rack.something" => "value"}
      headers.rackify(env)
      assert_equal({
        "rack.something" => "value",
      }, env)
    end

    def test_compatibility_trust
      headers = Headers.new({"Content-Type" => "CT"}, true)
      assert_equal nil, headers['content-type']
    end

    def test_compatibility_direct_access
      headers = Headers.new(source = {"content-type" => "CT"}, true)
      assert_equal "CT", headers['content-type']
      headers['Content-type'] = "NEW"
      assert_equal "NEW", headers['content-Type']
      assert_equal "NEW", source['content-type']
    end

  end
end
