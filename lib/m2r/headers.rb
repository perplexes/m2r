require 'delegate'

module M2R
  # Normalize headers access so that it is not case-sensitive
  # @api public
  class Headers
    include Enumerable

    # @param [Hash, #inject] hash Collection of headers
    def initialize(hash = {})
      @headers = hash.inject({}) do |headers,(header,value)|
        headers[transform_key(header)] = value
        headers
      end
    end

    # Get header
    # @param [String] header HTTP Header key
    def [](header)
      @headers[transform_key(header)]
    end

    # Set header
    # @param [String] header HTTP Header key
    # @param [String] value HTTP Header value
    def []=(header, value)
      @headers[transform_key(header)] = value
    end

    # Delete header
    # @param [String] header HTTP Header key
    def delete(header)
      @headers.delete(transform_key(header))
    end

    # Iterate over headers
    def each
      @headers.each { |k, v| yield [k, v] }
    end

    # Fill Hash with Headers compatibile with Rack standard.
    # Every header except for Content-Length and Content-Type
    # is capitalized, underscored, and prefixed with HTTP.
    # Content-Length and Content-Type are not prefixed
    # (according to the spec)
    #
    # @param [Hash] env Hash representing Rack Env or compatible
    # @return [Hash] same Hash as provided as param.
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
