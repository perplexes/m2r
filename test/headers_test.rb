require 'test_helper'

module M2R
  class HandlerTest < MiniTest::Unit::TestCase
    def test_downcasing
      headers = Headers.new({"Content-Type" => "CT", "type" => "Ty"})
      assert_equal "CT", headers['content-type']
      assert_equal "Ty", headers['type']
    end
  end
end
