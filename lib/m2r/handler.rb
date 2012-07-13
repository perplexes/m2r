require 'm2r/connection'

module M2R
  class Handler
    attr_accessor :connection
    def initialize(sender_uuid, subscribe_address, publish_address)
      @connection = M2R::Connection.new(sender_uuid,
                                        subscribe_address, publish_address)
    end

    # Callback for when the handler is waiting for a request
    def on_wait(*args)
    end

    # Callback when a request is received (for debug)
    def on_request(request, *args)
    end

    # Override this to return a custom response
    def process(request, *args)
      puts "PROCESS REQUEST: #{request}"
      #raise NoHandlerDefined, "define process_request in your subclass"
      return request.inspect
    end

    # Callback for when the server disconnects
    def on_disconnect(request, *args)
    end

    # Callback after process_request is done
    def after_process(response, request, *args)
      return response
    end

    # Callback after the server gets the response
    def after_reply(request, response, *args)
    end

    # the body of the main recv loop
    def listen
      loop do
        on_wait

        # get the request from Mongrel2 on the UPSTREAM socket
        request = @connection.recv
        # run the on_request hook
        on_request(request)

        # run on_disconnect if the server disconnects
        if request.disconnect?
          on_disconnect
          next
        end

        # get the response from on_request
        response = process(request)

        # run the response through a filter
        response = after_process(response, request)

        # send it back to the server on the PUB socket
        @connection.reply_http(request, response)

        after_reply(request, response)
      end
    end
  end
end
