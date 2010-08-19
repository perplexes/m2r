module Mongrel2
  class Handler
    attr_accessor :connection
    def initialize(sender_uuid, subscribe_address, publish_address) 
      @connection = Mongrel2::Connection.new(sender_uuid,
                      subscribe_address, publish_address)
    end

    def on_request(request)
      puts "ON REQUEST: #{request}"
    end

    def process_request(request) 
      puts "PROCES REQUEST: #{request}"
      #raise NoHandlerDefined, "define process_request in your subclass"
      return request.inspect
    end

    def on_disconnect(request)
      puts "ON DISCONNECT: #{request}"
    end
  
    def listen
      loop do
        # get the request from Mongrel2 on the SUB socket
        request = @connection.recv
        # run the on_request hook
        on_request

        # run on_disconnect if the server disconnects
        if request.disconnect?
          on_disconnect
          next
        end
          
        # get the response from on_request
        response = process_request(request) 

        # send it back to the server on the PUB socket
        @connection.reply_http(request, response)
      end
    end
  end
end
