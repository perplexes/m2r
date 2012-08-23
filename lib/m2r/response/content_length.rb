require 'm2r/response'

module M2R
  class Response
    # Adds Content-Length header based on body size
    # This is mostly required when you use bare
    # Response class without any framework on top of it
    # because HTTP clients require it when there is
    # body in response. Otherwise clients hang out.
    #
    # @api public
    module ContentLength
      def headers
        super.merge('Content-Length' => body.bytesize)
      end
    end
  end
end
