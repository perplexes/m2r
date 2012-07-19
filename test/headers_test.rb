require 'test_helper'

class HeadersTest < MiniTest::Unit::TestCase
  def test_case_insensitivity
    headers = M2R::Headers.new({"Content-Type" => "CT"})
    assert_equal "CT", headers['content-type']
    assert_equal "CT", headers['Content-Type']
    assert_equal "CT", headers['Content-type']
  end

  def test_symbols_as_keys
    headers = M2R::Headers.new({"type" => "Ty"})
    assert_equal "Ty", headers[:type]
  end

  def test_rackify
    headers = M2R::Headers.new({
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
