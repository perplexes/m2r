require 'test_helper'

class M2RTest < MiniTest::Unit::TestCase
  def test_mongrel2_context_getter
    M2R.singleton_class.class_eval { @zmq_context = nil } # hack
    assert_instance_of ZMQ::Context, M2R.zmq_context
  end

  def test_mongrel2_context_setter
    ctx = ZMQ::Context.new(2)
    M2R.zmq_context = ctx
    assert_equal ctx, M2R.zmq_context
  end
end
