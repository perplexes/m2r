require 'test_helper'

module M2R
  class HeadersTest < MiniTest::Unit::TestCase
    def test_case_insensitivity
      headers = Headers.new({"Content-Type" => "CT"})
      assert_equal "CT", headers['content-type']
      assert_equal "CT", headers['Content-Type']
      assert_equal "CT", headers['Content-type']
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

  end
end
