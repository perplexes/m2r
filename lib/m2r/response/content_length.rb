require 'm2r/response'

module M2R
  class Response
    module ContentLength
      def headers
        super.merge('Content-Length' => body.bytesize)
      end
    end
  end
end
