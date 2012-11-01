require 'm2r'
require 'ostruct'

module M2R
  # {Connection} factory so that every thread can use it generate its own
  # {Connection} for communication with Mongrel2.
  #
  # @api public
  class ConnectionFactory
    Options = Struct.new(:sender_id, :recv_addr, :send_addr)

    # @option options [String, nil] sender_id {ZMQ::IDENTITY} option for response socket
    # @option options [String] recv_addr ZMQ connection address. This is the
    #   send_spec option from Handler configuration in mongrel2.conf
    # @option options [String] send_addr ZMQ connection address. This is the
    #   recv_spec option from Handler configuration in mongrel2.conf
    # @param [ZMQ::Context] context Context for creating new ZMQ sockets
    def initialize(options = OpenStruct.new({}), context = M2R.zmq_context)
      options         = OpenStruct.new(options) if Hash === options
      @sender_id      = options.sender_id.to_s
      @request_addr   = options.recv_addr.to_s
      @response_addr  = options.send_addr.to_s
      @context        = context
    end

    # Builds new Connection which can be used to receive, parse
    # Mongrel2 requests and send responses.
    #
    # @return [Connection]
    def connection
      request_socket = @context.socket(ZMQ::PULL)
      request_socket.connect(@request_addr)

      response_socket = @context.socket(ZMQ::PUB)
      response_socket.connect(@response_addr)
      response_socket.setsockopt(ZMQ::IDENTITY, @sender_id) if @sender_id

      Connection.new(request_socket, response_socket)
    end

  end
end
