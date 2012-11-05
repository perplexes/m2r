require 'm2r'

module M2R
  # Connection for exchanging data with mongrel2
  class Connection
    class Error < StandardError
      attr_accessor :errno
      def signal?
        errno == ZMQ::EINTR
      end
    end

    # @param [ZMQ::Socket] request_socket socket for receiving requests
    #   from Mongrel2
    # @param [ZMQ::Socket] response_socket socket for sending responses
    #   to Mongrel2
    # @api public
    def initialize(request_socket, response_socket)
      @request_socket  = request_socket
      @response_socket = response_socket
    end

    # For compatibility with {M2R::ConnectionFactory}
    #
    # @return [Connection] self
    # @api public
    def connection
      self
    end

    # Returns Mongrel2 request
    #
    # @note This is blocking call
    # @return [String] M2 request message
    # @api public
    def receive
      ret = @request_socket.recv_string(msg = "")
      if ret < 0
        e = Error.new "Unable to receive message: #{ZMQ::Util.error_string}"
        e.errno = ZMQ::Util.errno
        raise e
      end
      return msg
    end

    # Sends response to Mongrel2 for given request
    #
    # @param [Response, #to_s] response_or_string Response
    #   for the request. Anything convertable to [String]
    # @return [String] M2 response message
    # @api public
    def reply(request, response_or_string)
      deliver(request.sender, request.conn_id, response_or_string.to_s)
      deliver(request.sender, request.conn_id, "") if close?(request, response_or_string)
    end

    # Delivers data to multiple mongrel2 connections.
    # Useful for streaming.
    #
    # @param [String] uuid Mongrel2 instance uuid
    # @param [Array<String>, String] connection_ids Mongrel2 connections ids
    # @param [String] data Data that should be delivered to the connections
    # @return [String] M2 response message
    #
    # @api public
    def deliver(uuid, connection_ids, data, trial = 1)
      msg = "#{uuid} #{TNetstring.dump([*connection_ids].join(' '))} #{data}"
      ret = @response_socket.send_string(msg, ZMQ::NOBLOCK)
      if ret < 0
        e = Error.new "Unable to deliver message: #{ZMQ::Util.error_string}"
        e.errno = ZMQ::Util.errno
        raise e
      end
      return msg
    rescue Connection::Error => er
      raise if trial >= 3
      raise unless er.signal?
      deliver(uuid, connection_ids, data, trial + 1)
    end

    def close
      @request_socket.close
      @response_socket.close
    end

    private

    def close?(request, response_or_string)
      if response_or_string.respond_to?(:close?)
        response_or_string.close?
      else
        request.close?
      end
    end

    attr_reader :request_socket
    attr_reader :response_socket
  end
end
