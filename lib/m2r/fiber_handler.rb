require 'm2r/handler'

module M2R
  class FiberHandler < Handler
    def initialize(*args)
      raise "This handler is just around for testing. don't use it, it'll suck."
    end

    def fiber_handle
      @fiber ||= Fiber.new do |request|
        loop do
          on_request(request)

          # run on_disconnect if the server disconnects
          if request.disconnect?
            on_disconnect
            request = Fiber.yield
            next
          end

          # get the response from on_request
          response = process(request)

          # run the response through a filter
          response = after_process(response, request)

          # send it back to the server on the PUB socket
          @connection.reply_http(request, response)

          after_reply(request, response)
          request = Fiber.yield
        end
      end
    end

    def listen
      loop do
        on_wait
        request = @connection.recv
        fiber_handle.resume(request)
      end
    end

  end
end
