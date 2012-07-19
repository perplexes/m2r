require 'test_helper'

class TestRequest < MiniTest::Unit::TestCase
  def test_parse
    data = %q[FAKESENDER 0 / 76:{"PATH":"/","host":"default","METHOD":"HEAD","VERSION":"HTTP/1.1","URI":"/"},0:,]
    request = M2R::Request.parse(data)

    assert_equal "/", request.path
    assert_equal "default", request.headers['Host']
    assert_equal "HEAD", request.method
    assert_equal nil, request.query
    assert_equal nil, request.pattern
  end
end
