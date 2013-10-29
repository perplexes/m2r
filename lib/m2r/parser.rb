require 'm2r/request'

module M2R
  # Mongrel2 Request Parser
  # @api public
  class Parser
    # Parse Mongrel2 request received via ZMQ message
    #
    # @param [String] msg Monrel2 Request message formatted according to rules
    #   of creating it described it m2 manual.
    # @return [Request]
    #
    # @api public
    # @threadsafe true
    def parse(msg)
      sender, conn_id, path, rest = msg.split(' ', 4)

      headers, rest = TNetstring.parse(rest)
      body, _       = TNetstring.parse(rest)
      headers       = JSON.load(headers)
      headers, mong = split_headers(headers)
      headers       = Headers.new headers, true
      mong          = Headers.new mong, true
      Request.new(sender, conn_id, path, headers, mong, body)
    end

    private

    def split_headers(headers)
      http    = {}
      mongrel = {}
      headers.each do |header, value|
        if Request::MONGREL2_HEADERS.include?(header)
          mongrel[header.downcase] = value
        else
          http[header] = value
        end
      end
      return http, mongrel
    end

  end
end

