require 'bbq/test'
require 'bbq/test_user'

class TestUser < Bbq::TestUser
  include MiniTest::Assertions

  def initialize
    super(:driver => :mechanize)
  end

  def see!(*args)
    msg = "Expected to see %s but not found"
    args.each { |arg| assert has_content?(arg), msg % arg }
  end
end
