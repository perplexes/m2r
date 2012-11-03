require 'm2r/response'

module M2R
  class Response
    # Adds Content-Length header based on body size
    # This is mostly required when you use bare
    # Response class without any framework on top of it.
    # HTTP clients require such header when there is
    # body in response. Otherwise they hang out.
    #
    # @api public
    module ContentLength
      def headers(value = GETTER)
        if value == GETTER
          h = super
          h['Content-Length'] ||= body.bytesize
          h
        else
          super
        end
      end
    end
  end
end
