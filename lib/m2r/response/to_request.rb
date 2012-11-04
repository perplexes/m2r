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
      # @return [self] Response object
      # @api public
      def to(request)
        http_version(request.http_version)
        headers['Connection'] = 'close' if request.close?
        self
      end
    end
  end
end

