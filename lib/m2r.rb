require 'rubygems'
require 'ffi-rzmq'

module M2R
  class << self
    attr_writer :zmq_context

    def zmq_context(threads = 1)
      @zmq_context ||= ZMQ::Context.new(threads)
    end
  end
end

Mongrel2 = M2R
