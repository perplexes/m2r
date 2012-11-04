require 'm2r/response'

module M2R
  class Response

    # Handles the logic of having response with proper
    # http version and 'Connection' header in relation to
    # given request
    #
    # @api public
    module ToRequest
      # params [Request] request Request that response handles
      # params [true, false] identical Whether http version in response should be identical
      #   to the received one.
      # @return [self] Response object
      # @api public
      def to(request, identical = false)
        # http://www.ietf.org/rfc/rfc2145.txt
        # 2.3 Which version number to send in a message
        http_version(request.http_version) if identical
        headers['Connection'] = 'close' if request.close?
        self
      end
    end
  end
end
