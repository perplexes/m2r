require 'm2r'

module M2R
  class Connection

    def initialize(request_socket, response_socket)
      @request_socket  = request_socket
      @response_socket = response_socket
    end

    def self.for(sender_id, request_addr, response_addr, context = M2R.zmq_context)
      request_socket = context.socket(ZMQ::PULL)
      request_socket.connect(request_addr)

      response_socket = context.socket(ZMQ::PUB)
      response_socket.connect(response_addr)
      response_socket.setsockopt(ZMQ::IDENTITY, sender_id)

      new(request_socket, response_socket)
    end

    def receive
      @request_socket.recv_string(msg = "")
      Request.parse(msg)
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
