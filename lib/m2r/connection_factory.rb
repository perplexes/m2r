require 'm2r'

module M2R
  class ConnectionFactory

    def initialize(sender_id, request_addr, response_addr, request_parser = Request, context = M2R.zmq_context)
      @sender_id      = sender_id.to_s
      @request_addr   = request_addr.to_s
      @response_addr  = response_addr.to_s
      @request_parser = request_parser
      @context        = context
    end

    def connection
      request_socket = @context.socket(ZMQ::PULL)
      request_socket.connect(@request_addr)

      response_socket = @context.socket(ZMQ::PUB)
      response_socket.connect(@response_addr)
      response_socket.setsockopt(ZMQ::IDENTITY, @sender_id)

      Connection.new(request_socket, response_socket, @request_parser)
    end

  end
end
