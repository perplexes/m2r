require 'test_helper'
require 'bbq/test'
require 'bbq/test_user'
require 'capybara'
require 'capybara/mechanize'

Capybara.app_host = "http://localhost:6767/"
Capybara.current_driver = :mechanize

class TestUser < Bbq::TestUser
  include MiniTest::Assertions

  def see!(*args)
    args.each do |arg|
      assert has_content?(arg), %Q/Expected to see "#{arg}" but not found./
    end
  end
end

module M2R
  class AcceptanceTest < MiniTest::Unit::TestCase

    def test_requests
      pid = Process.spawn("bundle exec foreman start --procfile=example/Procfile")
      sleep(1)
      user = TestUser.new(:driver => :mechanize)
      user.visit("/handler")
      user.see!("SENDER", "PATH", "HEADERS", "x-forwarded-for", "x-forwarded-for", "BODY")

      user.visit("/rack")
      assert user.find("pre").text.include?(" {{{{{{ { ( ( (  (   (-----:=")

      user.click_on("flip!")
      assert user.find("pre").text.include?("=:-----(   (  ( ( ( { {{{{{{")
    ensure
      Process.kill("KILL", pid) if pid
    end

  end
end
