require 'test_helper'

module M2R
  class AcceptanceTest < MiniTest::Unit::TestCase
    include ProcessHelper

    def test_rack_example
      user = TestUser.new
      user.visit("/handler")
      user.see!("SENDER", "PATH", "HEADERS", "x-forwarded-for", "x-forwarded-for", "BODY")
    end

    def test_handler_example
      user = TestUser.new
      user.visit("/rack")
      assert user.find("pre").text.include?(" {{{{{{ { ( ( (  (   (-----:=")
      user.click_on("flip!")
      assert user.find("pre").text.include?("=:-----(   (  ( ( ( { {{{{{{")
    end
  end
end
