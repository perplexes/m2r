require 'rubygems'
require 'ffi-rzmq'
require 'multi_json'
require 'tnetstring'
require 'thread'

module M2R
  class << self
    attr_writer :zmq_context

    def zmq_context(threads = 1)
      Thread.exclusive do
        @zmq_context ||= ZMQ::Context.new(threads)
      end
    end
  end
end

Mongrel2 = M2R

require 'm2r/request'
require 'm2r/response'
require 'm2r/connection'
require 'm2r/connection_factory'
require 'm2r/handler'
