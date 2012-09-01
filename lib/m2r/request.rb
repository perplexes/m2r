require 'm2r'
require 'm2r/request/base'
require 'm2r/request/upload'
require 'm2r/headers'

module M2R
  # Abstraction over Mongrel 2 request. Allows
  # @api public
  class Request
    MONGREL2_HEADERS = %w(pattern method path query).map(&:freeze).freeze

    include Base
    include Upload

    # @return [String] UUID of mongrel2 origin instance
    attr_reader :sender

    # @return [String] Mongrel2 connection id sending this request
    attr_reader :conn_id

    # @return [String] HTTP Path of request
    attr_reader :path

    # @return [String] HTTP Body of request
    attr_reader :body

    # @param [String] sender UUID of mongrel2 origin instance
    # @param [String] conn_id Mongrel2 connection id sending this request
    # @param [String] path HTTP Path of request
    # @param [M2R::Headers] HTTP headers of request
    # @param [String] body HTTP Body of request
    def initialize(sender, conn_id, path, headers, body)
      @http_headers, @mongrel_headers = split_headers(headers)
      @sender  = sender
      @conn_id = conn_id
      @path    = path
      @body    = body
      @data    = MultiJson.load(@body) if json?
    end

    # Parse Mongrel2 request received via ZMQ message
    #
    # @param [String] msg Monrel2 Request message formatted according to rules
    #   of creating it described it m2 manual.
    # @return [Request]
    #
    # @api public
    def self.parse(msg)
      sender, conn_id, path, rest = msg.split(' ', 4)

      headers, rest = TNetstring.parse(rest)
      body, _       = TNetstring.parse(rest)
      headers       = Headers.new MultiJson.load(headers)
      self.new(sender, conn_id, path, headers, body)
    end

    # @return [M2R::Headers] HTTP headers
    def headers
      @http_headers
    end

    # @return [String] Mongrel2 pattern used to match this request
    def pattern
      @mongrel_headers['pattern']
    end

    # @return [String] HTTP method
    def method
      @mongrel_headers['method']
    end

    # @return [String] Request query string
    def query
      @mongrel_headers['query']
    end

    # @return [true, false] Internal mongrel2 message to handler issued when
    #   message delivery is not possible because the client already
    #   disconnected and there is no connection with such conn_id
    def disconnect?
      json? and @data['type'] == 'disconnect'
    end

    # @return [true, false] Information whether HTTP Connection should
    #   be closed after processing the request. Happens when HTTP/1.0
    #   or request has Connection=close header.
    def close?
      unsupported_version? or connection_close?
    end

    protected

    def unsupported_version?
      @http_headers['version'] != 'HTTP/1.1'
    end

    def connection_close?
      @http_headers['connection'] == 'close'
    end

    def json?
      method == 'JSON'
    end

    def split_headers(headers)
      mongrel = Headers.new
      mongrel_headers.each do |header|
        next unless headers[header]
        mongrel[header] = headers.delete(header)
      end
      return headers, mongrel
    end
  end
end
