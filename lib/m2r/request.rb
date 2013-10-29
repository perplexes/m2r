require 'set'
require 'm2r/http/close'
require 'm2r/request/base'
require 'm2r/request/upload'
require 'm2r/headers'

module M2R
  # Abstraction over Mongrel 2 request
  # @api public
  class Request
    # @api private
    TRUE_STRINGS            = Set.new(%w(true yes on 1).map(&:freeze)).freeze
    # @api private
    MONGREL2_BASE_HEADERS   = Set.new(%w(pattern method path query url_scheme version).map(&:upcase).map(&:freeze)).freeze
    # @api private
    MONGREL2_UPLOAD_HEADERS = Set.new(%w(x-mongrel2-upload-start x-mongrel2-upload-done).map(&:downcase).map(&:freeze)).freeze
    # @api private
    MONGREL2_HEADERS        = (MONGREL2_BASE_HEADERS + MONGREL2_UPLOAD_HEADERS).freeze

    include Base
    include Upload
    include HTTP::Close

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
    # @param [M2R::Headers] headers HTTP headers of request
    # @param [M2R::Headers] headers Additional mongrel2 headers
    # @param [String] body HTTP Body of request
    def initialize(sender, conn_id, path, http_headers, mongrel_headers, body)
      @sender           = sender
      @conn_id          = conn_id
      @path             = path
      @http_headers     = http_headers
      @mongrel_headers  = mongrel_headers
      @body             = body
      @data             = JSON.load(@body) if json?
    end

    # Parse Mongrel2 request received via ZMQ message
    #
    # @param [String] msg Monrel2 Request message formatted according to rules
    #   of creating it described it m2 manual.
    # @return [Request]
    #
    # @api public
    # @deprecated
    def self.parse(msg)
      Parser.new.parse(msg)
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

    # return [String] URL scheme
    def scheme
      @mongrel_headers['url_scheme'] || mongrel17_scheme
    end

    def http_version
      @mongrel_headers['version']
    end

    # @return [true, false] Internal mongrel2 message to handler issued when
    #   message delivery is not possible because the client already
    #   disconnected and there is no connection with such {#conn_id}
    def disconnect?
      json? and @data['type'] == 'disconnect'
    end

    protected

    def mongrel17_scheme
      return 'https' if TRUE_STRINGS.include? env_https
      return 'http'
    end

    def env_https
      (ENV['HTTPS'] || "").downcase
    end

    def json?
      method == 'JSON'
    end

  end
end
