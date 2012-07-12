require 'helper'

class TestM2r < MiniTest::Unit::TestCase
  def test_mongrel2_context_getter
    Mongrel2.singleton_class.class_eval { @zmq_context = nil } # hack
    assert_instance_of ZMQ::Context, Mongrel2.zmq_context
  end

  def test_mongrel2_context_setter
    ctx = ZMQ::Context.new(2)
    Mongrel2.zmq_context = ctx
    assert_equal ctx, Mongrel2.zmq_context
  end
end
