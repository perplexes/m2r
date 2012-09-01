require 'm2r'
require 'm2r/response/content_length'

module M2R
  # Simplest possible abstraction layer over HTTP request
  #
  # @api public
  class Response

    # @private
    VERSION      = "HTTP/1.1".freeze

    # @private
    CRLF         = "\r\n".freeze

    # @private
    STATUS_CODES = {
      100 => 'Continue',
      101 => 'Switching Protocols',
      102 => 'Processing',
      200 => 'OK',
      201 => 'Created',
      202 => 'Accepted',
      203 => 'Non-Authoritative Information',
      204 => 'No Content',
      205 => 'Reset Content',
      206 => 'Partial Content',
      207 => 'Multi-Status',
      226 => 'IM Used',
      300 => 'Multiple Choices',
      301 => 'Moved Permanently',
      302 => 'Found',
      303 => 'See Other',
      304 => 'Not Modified',
      305 => 'Use Proxy',
      306 => 'Reserved',
      307 => 'Temporary Redirect',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Long',
      415 => 'Unsupported Media Type',
      416 => 'Requested Range Not Satisfiable',
      417 => 'Expectation Failed',
      418 => "I'm a Teapot",
      422 => 'Unprocessable Entity',
      423 => 'Locked',
      424 => 'Failed Dependency',
      426 => 'Upgrade Required',
      500 => 'Internal Server Error',
      501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
    }
    STATUS_CODES.freeze

    # @return [Fixnum] HTTP Status code
    attr_reader :status

    # @return [Hash, Headers] Collection of response HTTP Headers
    attr_reader :headers

    # @return [String] HTTP Body
    attr_reader :body

    # @return [String] HTTP Status code description
    attr_reader :reason

    # @param [Fixnum, #to_i] status HTTP status code
    # @param [Hash] headers HTTP headers
    # @param [String, nil] body HTTP body
    def initialize(status, headers, body = nil)
      @status  = status.to_i
      @headers = headers
      @body    = body || ""
      @reason  = STATUS_CODES[status.to_i]
    end

    # @return [String] HTTP Response
    def to_s
      response = "#{VERSION} #{status} #{reason}#{CRLF}"
      unless headers.empty?
        response << headers.map { |h, v| "#{h}: #{v}" }.join(CRLF) << CRLF
      end
      response << CRLF
      response << body
      response
    end
  end
end
