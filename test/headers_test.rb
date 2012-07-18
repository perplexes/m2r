require 'test_helper'

module M2R
  class HandlerTest < MiniTest::Unit::TestCase
    def test_downcasing
      headers = Headers.new({"Content-Type" => "CT", "type" => "Ty"})
      assert_equal "CT", headers['content-type']
      assert_equal "Ty", headers['type']
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
  end
end
