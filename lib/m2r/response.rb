require 'm2r'
require 'm2r/http/close'
require 'm2r/response/content_length'

module M2R
  # Simplest possible abstraction layer over HTTP request
  #
  # @api public
  class Response
    include HTTP::Close

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

    attr_reader :reason

    def initialize
      status(200)
      headers(Headers.new)
      body("")
      http_version(VERSION)
    end

    # @param [Fixnum, #to_i] value HTTP status code
    def status(value = GETTER)
      if value == GETTER
        @status
      else
        @status = value.to_i
        @reason = STATUS_CODES[@status]
        self
      end
    end

    # @param [Hash] value HTTP headers
    def headers(value = GETTER)
      if value == GETTER
        @headers
      else
        @headers = value
        self
      end
    end

    # @param [Hash] header HTTP header key
    # @param [Hash] value HTTP header value
    def header(header, value = GETTER)
      if value == GETTER
        @headers[header]
      else
        @headers[header] = value
        self
      end
    end

    # @param [String, nil] value HTTP body
    def body(value = GETTER)
      if value == GETTER
        @body
      else
        @body = value
        self
      end
    end

    # @param [String, nil] version HTTP body
    def http_version(value = GETTER)
      if value == GETTER
        @version
      else
        @version = value
        self
      end
    end

    # @return [String] HTTP Response
    def to_s
      response = "#{http_version} #{status} #{reason}#{CRLF}"
      unless headers.empty?
        response << headers.map { |h, v| "#{h}: #{v}" }.join(CRLF) << CRLF
      end
      response << CRLF
      response << body.to_s
      response
    end

    protected

    GETTER = Object.new
  end
end
