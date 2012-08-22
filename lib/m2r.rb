require 'ffi-rzmq'
require 'multi_json'
require 'tnetstring'
require 'thread'

# Public: Allows you to easily interact with Mongrel2 webserver from
# your ruby code.
module M2R
  class << self
    # Public: Sets ZMQ context used by M2R to create sockets
    attr_writer :zmq_context

    # Public: Gets (or sets if not existing) ZMQ context used by M2R
    # to create sockets.
    #
    # This method is thread-safe but it uses Thread.exclusive to achive that.
    # However it is unlikely that it affects the performance as you probably
    # do not create more than a dozen of sockets in your code.
    #
    # zmq_io_threads - Size of the ØMQ thread pool to handle I/O operations.
    #                  The rule of thumb is to make it equal to the number
    #                  gigabits per second that the application will produce.
    #                  Integer. (default: 1).
    #
    # Returns ZMQ::Context
    def zmq_context(zmq_io_threads = 1)
      Thread.exclusive do
        @zmq_context ||= ZMQ::Context.new(zmq_io_threads)
      end
    end
  end
end

# Deprecated: Namespace used in the past in 0.0.* gem releases
Mongrel2 = M2R

require 'm2r/request'
require 'm2r/response'
require 'm2r/connection'
require 'm2r/connection_factory'
require 'm2r/handler'
