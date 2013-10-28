require 'ostruct'

module M2R
  # {Connection} factory so that every thread can use it generate its own
  # {Connection} for communication with Mongrel2.
  #
  # @api public
  class ConnectionFactory
    class Options < Struct.new(:sender_id, :recv_addr, :send_addr)
      # @param [String, nil] sender_id {ZMQ::IDENTITY} option for response socket
      # @param [String] recv_addr ZMQ connection address. This is the
      #   send_spec option from Handler configuration in mongrel2.conf
      # @param [String] send_addr ZMQ connection address. This is the
      #   recv_spec option from Handler configuration in mongrel2.conf
      def initialize(sender_id, recv_addr, send_addr)
        super
      end
    end

    # @param [Options] options ZMQ connections options
    # @param [ZMQ::Context] context Context for creating new ZMQ sockets
    def initialize(options, context = M2R.zmq_context)
      @options = options
      @context = context
    end

    # Builds new Connection which can be used to receive
    # Mongrel2 requests and send responses.
    #
    # @return [Connection]
    def connection
      request_socket = @context.socket(ZMQ::PULL)
      request_socket.connect(@options.recv_addr)

      response_socket = @context.socket(ZMQ::PUB)
      response_socket.connect(@options.send_addr)
      response_socket.setsockopt(ZMQ::IDENTITY, @options.sender_id) if @options.sender_id

      Connection.new(request_socket, response_socket)
    end

  end
end
