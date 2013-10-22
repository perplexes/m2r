require 'test_helper'
require 'timeout'

module M2R
  class ModuleTest < MiniTest::Unit::TestCase
    def setup
      if context = M2R.instance_variable_get(:@zmq_context)
        context.send(:remove_finalizer) if context.respond_to?(:remove_finalizer)
        M2R.instance_variable_set(:@zmq_context, nil)
      end
    end

    def test_mongrel2_context_getter
      assert_instance_of ZMQ::Context, M2R.zmq_context
    end

    def test_mongrel2_context_setter
      ctx = ZMQ::Context.new(2)
      M2R.zmq_context = ctx
      assert_equal ctx, M2R.zmq_context
    end

    def test_only_1_context_created_when_race_condition
      threads = nil
      ZMQ::Context.expects(:new).returns(true).once

      Thread.exclusive do
        threads = 512.times.map do
          Thread.new do
            M2R.zmq_context
          end
        end
      end
      Timeout.timeout(5) do
        threads.each(&:join)
      end

      M2R.zmq_context = nil
    end

  end
end
