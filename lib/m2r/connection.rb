require 'm2r'

module M2R
  class Connection

    def initialize(request_socket, response_socket, request_parser = Request)
      @request_socket  = request_socket
      @response_socket = response_socket
      @request_parser  = request_parser
    end

    def connection
      self
    end

    def receive
      @request_socket.recv_string(msg = "")
      @request_parser.parse(msg)
    end

    def reply(request, response_or_string)
      deliver(request.sender, request.conn_id, response_or_string.to_s)
    end

    def deliver(uuid, connection_ids, data)
      msg = "#{uuid} #{TNetstring.dump([*connection_ids].join(' '))} #{data}"
      @response_socket.send_string(msg)
    end
  end
end
