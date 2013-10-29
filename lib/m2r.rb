require 'ffi-rzmq'
require 'json'
require 'tnetstring'
require 'thread'

# Allows you to easily interact with Mongrel2 webserver from
# your ruby code.
# @api public
module M2R
  class << self

    # Sets ZMQ context used by M2R to create sockets
    # @param [ZMQ::Context] value Context to by used by M2R
    # @see #zmq_context
    # @api public
    attr_writer :zmq_context

    # Gets (or sets if not existing) ZMQ context used by M2R
    # to create sockets.
    #
    # @note This method is thread-safe
    #   but it uses Thread.exclusive to achive that.
    #   However it is unlikely that it affects the performance as you probably
    #   do not create more than a dozen of sockets in your code.
    #
    # @param [Fixnum] zmq_io_threads Size of the ZMQ thread pool to handle I/O operations.
    #   The rule of thumb is to make it equal to the number gigabits per second
    #   that the application will produce.
    #
    # @return [ZMQ::Context]
    # @see #zmq_context=
    # @api public
    def zmq_context(zmq_io_threads = 1)
      Thread.exclusive do
        @zmq_context ||= ZMQ::Context.new(zmq_io_threads)
      end
    end
  end
end

# @deprecated: Use M2R instead
#   Namespace used in the past in 0.0.* gem releases
Mongrel2 = M2R

require 'm2r/request'
require 'm2r/parser'
require 'm2r/response'
require 'm2r/reply'
require 'm2r/connection'
require 'm2r/connection_factory'
require 'm2r/handler'
require 'm2r/multithread_handler'
