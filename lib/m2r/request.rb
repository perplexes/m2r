require 'm2r'

module M2R
  class Request
    attr_reader :sender, :conn_id, :path, :headers, :body

    def initialize(sender, conn_id, path, headers, body)
      @sender  = sender
      @conn_id = conn_id
      @path    = path
      @headers = headers
      @body    = body
      @data    = json? ? JSON.parse(@body) : {}
    end

    def self.parse(msg)
      sender, conn_id, path, rest = msg.split(' ', 4)

      headers, rest = TNetstring.parse(rest)
      body, _       = TNetstring.parse(rest)
      headers       = JSON.parse(headers)

      self.new(sender, conn_id, path, headers, body)
    end

    def method
      headers['METHOD']
    end

    def disconnect?
      json? && @data['type'] == 'disconnect'
    end
    alias :is_disconnect :disconnect?

    def close?
      headers['VERSION']    == 'HTTP/1.0' ||
      headers['connection'] == 'close'
    end

    protected

    def json?
      method == 'JSON'
    end
  end
end
