require 'm2r'

module M2R
  class Handler
    attr_accessor :connection
    def initialize(connection)
      @connection = connection
    end

    def self.for(sender_uuid, subscribe_address, publish_address)
      new(Connection.new(sender_uuid, subscribe_address, publish_address))
    end

    # Callback for when the handler is waiting for a request
    def on_wait()
    end

    # Callback when a request is received (for debug)
    def on_request(request)
    end

    # Override this to return a custom response
    def process(request)
      raise NotImplementedError
    end

    # Callback for when the server disconnects
    def on_disconnect(request)
    end

    def on_upload_start(request)
    end

    def on_upload_done(request)
    end

    # Callback after process_request is done
    def after_process(request, response)
      return response
    end

    # Callback after the server gets the response
    def after_reply(request, response)
    end

    def listen
      loop do
        on_wait
        break if stop?
        request_lifecycle(@connection.receive)
      end
    end

    def request_lifecycle(request)
      on_request(request)

      return on_disconnect(request)   if request.disconnect?
      return on_upload_start(request) if request.upload_start?
      on_upload_done(request)         if request.upload_done?

      response = process(request)
      response = after_process(request, response)

      @connection.reply(request, response)

      after_reply(request, response)
    end

    protected

    def stop?
      @stop
    end

    def stop
      @stop = true
    end
  end
end
