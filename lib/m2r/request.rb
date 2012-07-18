require 'm2r'
require 'm2r/request/upload'
require 'm2r/headers'

module M2R
  class BaseRequest
    MongrelHeaders = %w(PATTERN METHOD PATH QUERY host).map(&:downcase).map(&:freeze).freeze
    attr_reader :sender, :conn_id, :path, :headers, :body, :mongrel

    def initialize(sender, conn_id, path, headers, body)
      @mongrel = {}
      @sender  = sender
      @conn_id = conn_id
      @path    = path
      @headers = parse_headers(headers)
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

    def disconnect?
      json? && @data['type'] == 'disconnect'
    end

    def close?
      http1_0? || connection_close?
    end

    def pattern
      mongrel['pattern']
    end

    def method
      mongrel['method']
    end

    def query
      mongrel['query']
    end

    def host
      mongrel['host']
    end

    def path
      mongrel['path']
    end

    def header(header)
      headers[header]
    end

    def version
      header('version')
    end

    def connection
      header('connection')
    end

    def http1_0?
      header(version)    == 'HTTP/1.0'
    end

    def connection_close?
      connection.downcase == 'close'
    end

    protected

    def json?
      method == 'JSON'
    end

    def parse_headers(headers)
      mongrel_headers.each do |header|
        next unless headers.key?(header)
        mongrel[header] = headers.delete(header)
      end
      return headers
    end

    def mongrel_headers
      MongrelHeaders
    end

  end

  class Request < BaseRequest
    include Upload
  end
end
