require 'rubygems'
require 'ffi-rzmq'
require 'json'

module M2R
  class << self
    attr_writer :zmq_context

    def zmq_context(threads = 1)
      @zmq_context ||= ZMQ::Context.new(threads)
    end
  end
end

Mongrel2 = M2R

require 'm2r/request'
require 'm2r/connection'
require 'm2r/handler'
