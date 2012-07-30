require 'bbq/test_user'

class TestUser < Bbq::TestUser
  include MiniTest::Assertions

  def see!(*args)
    args.each do |arg|
      assert has_content?(arg), %Q/Expected to see "#{arg}" but not found./
    end
  end
end


