require 'acceptance_helper'

module M2R
  class AcceptanceTest < MiniTest::Unit::TestCase

    def test_requests
      pid = Process.spawn("bundle exec foreman start --procfile=example/Procfile", pgroup: true, out: "/dev/null", err: "/dev/null")
      sleep(1)
      user = TestUser.new(:driver => :mechanize)
      user.visit("/handler")
      user.see!("SENDER", "PATH", "HEADERS", "x-forwarded-for", "x-forwarded-for", "BODY")

      user.visit("/rack")
      assert user.find("pre").text.include?(" {{{{{{ { ( ( (  (   (-----:=")

      user.click_on("flip!")
      assert user.find("pre").text.include?("=:-----(   (  ( ( ( { {{{{{{")
    ensure
      Process.kill("SIGTERM", pid) if pid
      sleep(1)
    end
  end

end
