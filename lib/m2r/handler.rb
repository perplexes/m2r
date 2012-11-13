require 'm2r'

module M2R

  # Basic handler, scaffold for your own Handler.
  # Overwrite hook methods to define behavior.
  # After calling #listen the Handler will block
  # waiting for request from connection generated
  # by {M2R::Handler#connection_factory}, process them and send
  # reponses back.
  #
  # @api public
  # @abstract Subclass and override method hooks to implement your own Handler
  class Handler
    # @return [Connection] used for receiving requests and sending responses
    attr_accessor :connection

    # @param [ConnectionFactory, Connection, #connection] connection_factory
    #   Factory for generating connections
    #
    # @param [#parse] parser
    #   Parser of M2 requests
    def initialize(connection_factory, parser)
      @connection = connection_factory.connection
      @parser     = parser
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
    # @api public
    # @!visibility public
    def on_wait()
    end

    # Callback when a request is received
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    def on_request(request)
    end

    # Override to return a response
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    # @return [Response, String, #to_s] Response that should be sent to
    #   Mongrel2 instance
    def process(request)
      raise NotImplementedError
    end

    # Callback executed when response could not be delivered by Mongrel2
    # because client already disconnected.
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    def on_disconnect(request)
    end

    # Callback when async-upload started
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    def on_upload_start(request)
    end

    # Callback when async-upload finished
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    def on_upload_done(request)
    end

    # Callback after process_request is done
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    # @param [Response, String, #to_s] response Response that should be sent to
    #   Mongrel2 instance
    def after_process(request, response)
      return response
    end

    # Callback after sending the response back
    # @api public
    # @!visibility public
    # @param [Request] request Request object
    # @param [Response, String, #to_s] response Response that was sent to
    #   Mongrel2 instance
    def after_reply(request, response)
    end

    # Callback after request is processed that is executed
    # even when execption occured. Useful for releasing
    # resources (closing files etc)
    # @api public
    # @!visibility public
    # @note `response` might be nil depending on when exception occured.
    # @note In case of error this callback is called before on_error
    # @param [Request] request Request object
    # @param [Response, String, #to_s, nil] response Response that was sent to
    #   Mongrel2 instance
    def after_all(request, response)
    end

    # Callback when exception occured
    # @api public
    # @!visibility public
    # @note `request` and/or `response` might be nil depending on when error occured
    # @param [Request, nil] request Request object
    # @param [Response, String, #to_s, nil] response Response that might have been sent to
    #   Mongrel2 instance
    # @param [StandardError] error
    def on_error(request, response, error)
    end

    # Callback when ZMQ interrupted by signal
    # @api public
    # @!visibility public
    def on_interrupted
    end

    private

    def next_request
      @parser.parse @connection.receive
    end

    def one_loop
      on_wait
      throw :stop if stop?
      response = request_lifecycle(request = next_request)
    rescue => error
      return on_interrupted if Connection::Error === error && error.signal?
      on_error(request, response, error)
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
      return response
    ensure
      after_all(request, response)
    end

    def stop?
      @stop
    end

  end
end
