require 'm2r'
require 'm2r/request/upload'
require 'm2r/headers'

module M2R
  class Request
    MONGREL2_HEADERS = %w(pattern method path query).map(&:freeze).freeze

    include Upload

    attr_reader :sender, :conn_id, :path, :body

    def initialize(sender, conn_id, path, headers, body)
      @http_headers, @mongrel_headers = split_headers(headers)
      @sender  = sender
      @conn_id = conn_id
      @path    = path
      @body    = body
      @data    = MultiJson.load(@body) if json?
    end

    def self.parse(msg)
      sender, conn_id, path, rest = msg.split(' ', 4)

      headers, rest = TNetstring.parse(rest)
      body, _       = TNetstring.parse(rest)
      headers       = Headers.new MultiJson.load(headers)
      self.new(sender, conn_id, path, headers, body)
    end

    def headers
      @http_headers
    end

    def pattern
      @mongrel_headers['pattern']
    end

    def method
      @mongrel_headers['method']
    end

    def query
      @mongrel_headers['query']
    end

    def disconnect?
      json? and @data['type'] == 'disconnect'
    end

    def close?
      unsupported_version? or connection_close?
    end

    protected

    def mongrel_headers
      (super if defined?(super)).to_a + MONGREL2_HEADERS
    end

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
