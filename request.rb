module Mongrel2
  class Request
    attr_reader :sender, :conn_id, :path, :headers, :body
    def initialize(sender, conn_id, path, headers, body)
      @sender = sender
      @conn_id = conn_id
      @path = path
      @headers = headers
      @body = body
      
      if headers['METHOD'] == 'JSON'
        @data = JSON.parse(@body)
      else
        @data = {}
      end
    end

    def self.parse_netstring(ns)
      len, rest = ns.split(':', 2)
      len = len.to_i
      raise "Netstring did not end in ','" unless rest[len].chr == ','
      [ rest[0...len], rest[(len+1)..-1] ]
    end
    
    def self.parse(msg)
      sender, conn_id, path, rest = msg.split(' ', 4)
      headers, head_rest = parse_netstring(rest)
      body, _ = parse_netstring(head_rest)

      headers = JSON.parse(headers)

      self.new(sender, conn_id, path, headers, body)
    end

    def is_disconnect
      if self.headers['METHOD'] == 'JSON'
        @data['type'] == 'disconnect'
      end
    end
  end # class Request
end # mod Mongrel2
    