require 'm2r'

module M2R
  # {Connection} factory so that every thread can use it generate its own
  # {Connection} for communication with Mongrel2.
  #
  # @api public
  class ConnectionFactory

    # @param [String, nil] sender_id {ZMQ::IDENTITY} option for response socket
    # @param [String] request_addr ZMQ connection address. This is the
    #   send_spec option from Handler configuration in mongrel2.conf
    # @param [String] response_addr ZMQ connection address. This is the
    #   recv_spec option from Handler configuration in mongrel2.conf
    # @param [#parse] request_parser Mongrel2 request parser
    # @param [ZMQ::Context] context Context for creating new ZMQ sockets
    def initialize(sender_id, request_addr, response_addr, request_parser = Request, context = M2R.zmq_context)
      @sender_id      = sender_id.to_s
      @request_addr   = request_addr.to_s
      @response_addr  = response_addr.to_s
      @request_parser = request_parser
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

      Connection.new(request_socket, response_socket, @request_parser)
    end

  end
end
