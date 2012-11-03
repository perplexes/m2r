require 'delegate'

module M2R
  # Normalize headers access so that it is not case-sensitive
  # @api public
  class Headers
    include Enumerable

    # @param [Hash, #inject] hash Collection of headers
    # @param [true, false] compatible Whether the hash already contains
    #   downcased strings only. If so it is going to be directly as
    #   container for the headers.
    def initialize(hash = {}, compatible = false)
      @headers = hash and return if compatible
      @headers = hash.inject({}) do |headers,(header,value)|
        headers[transform_key(header)] = value
        headers
      end
    end

    # Get header
    # @param [String, Symbol, #to_s] header HTTP Header key
    # @return [String, nil] Value of given Header, nil when not present
    def [](header)
      @headers[transform_key(header)]
    end

    # Set header
    # @param [String, Symbol, #to_s] header HTTP Header key
    # @param [String] value HTTP Header value
    # @return [String] Set value
    def []=(header, value)
      @headers[transform_key(header)] = value
    end

    # Delete header
    # @param [String, Symbol, #to_s] header HTTP Header key
    # @return [String, nil] Value of deleted header, nil when was not present
    def delete(header)
      @headers.delete(transform_key(header))
    end

    # Iterate over headers
    # @yield HTTP header and its value
    # @yieldparam [String] header HTTP Header name (downcased)
    # @yieldparam [String] value HTTP Header value
    # @return [Hash, Enumerator]
    def each(&proc)
      @headers.each(&proc)
    end

    # Fill Hash with Headers compatibile with Rack standard.
    # Every header except for Content-Length and Content-Type
    # is capitalized, underscored, and prefixed with HTTP.
    # Content-Length and Content-Type are not prefixed
    # (according to the spec)
    #
    # @param [Hash] env Hash representing Rack Env or compatible
    # @return [Hash] same Hash as provided as argument.
    def rackify(env = {})
      @headers.each do |header, value|
        key = "HTTP_" + header.upcase.gsub("-", "_")
        env[key] = value
      end
      env["CONTENT_LENGTH"] = env.delete("HTTP_CONTENT_LENGTH") if env.key?("HTTP_CONTENT_LENGTH")
      env["CONTENT_TYPE"]   = env.delete("HTTP_CONTENT_TYPE")   if env.key?("HTTP_CONTENT_TYPE")
      env
    end

    protected

    def transform_key(key)
      key.to_s.downcase
    end
  end
end
