
module Mongrel2
  class << self
    attr_writer :zmq_context

    def zmq_context(threads = 1)
      @zmq_context ||= ZMQ::Context.new(threads)
    end
  end
end

require 'connection'
require 'request'
require 'handler'
