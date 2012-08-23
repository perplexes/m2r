require 'm2r'

module M2R

  # Basic handler, scaffold for your own Handler.
  # Overwrite hook methods to define behavior.
  # After calling #listen the Handler will block
  # waiting for request from connection generated
  # by connection_factory, process them and send
  # reponses back.
  #
  # @api public
  class Handler
    # Connection used for receiving requests and
    # sending responses
    attr_accessor :connection

    # @param [ConnectionFactory, Connection, #connection] Factory for generating connections
    def initialize(connection_factory)
      @connection = connection_factory.connection
    end

    # Start processing request
    def listen
      catch(:stop) do
        loop { one_loop }
      end
    end

    # Schedule stop after processing request
    def stop
      @stop = true
    end

    protected

    # Callback executed when waiting for a request
    def on_wait()
    end

    # Callback when a request is received
    def on_request(request)
    end

    # Override to return a response
    def process(request)
      raise NotImplementedError
    end

    # Callback executed when response could not be delivered by Mongrel2
    # because client already disconnected.
    def on_disconnect(request)
    end

    # Callback when async-upload started
    def on_upload_start(request)
    end

    # Callback when async-upload finished
    def on_upload_done(request)
    end

    # Callback after process_request is done
    def after_process(request, response)
      return response
    end

    # Callback after sending the response back
    def after_reply(request, response)
    end

    # Callback after request is processed that is executed
    # even when execption occured. Useful for releasing
    # resources (closing files etc)
    def after_all(request, response)
    end

    private

    def one_loop
      on_wait
      throw :stop if stop?
      request_lifecycle(@connection.receive)
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
    ensure
      after_all(request, response)
    end

    def stop?
      @stop
    end

  end
end
