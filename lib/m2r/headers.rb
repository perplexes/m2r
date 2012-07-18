require 'delegate'

module M2R
  class Headers < DelegateClass(Hash)

    def initialize(hash = {})
      downcased = hash.inject({}) do |headers,(header,value)|
        headers[header.downcase] = value
        headers
      end
      super(downcased)
    end

    def rackify(env = {})
      inject(env) do |rack, (header, value)|
        key = "HTTP_" + header.upcase.gsub("-", "_")
        env[key] = value
      end
      env["CONTENT_LENGTH"] = env.delete("HTTP_CONTENT_LENGTH") if env.key?("HTTP_CONTENT_LENGTH")
      env["CONTENT_TYPE"]   = env.delete("HTTP_CONTENT_TYPE")   if env.key?("HTTP_CONTENT_TYPE")
      env
    end

  end
end
