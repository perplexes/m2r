require 'delegate'

module M2R
  class Headers
    include Enumerable

    def initialize(hash = {})
      @headers = hash.inject({}) do |headers,(header,value)|
        headers[transform_key(header)] = value
        headers
      end
    end

    def [](header)
      @headers[transform_key(header)]
    end

    def []=(header, value)
      @headers[transform_key(header)] = value
    end

    def delete(header)
      @headers.delete(transform_key(header))
    end

    def each
      @headers.each { |k, v| yield [k, v] }
    end

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
