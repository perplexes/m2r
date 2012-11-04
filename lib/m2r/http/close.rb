module M2R
  module HTTP

    # Detect that whether connection should be closed
    # based on http protocol version and `Connection' header
    # We do not support persistent connections for HTTP 1.0
    module Close

      # @return [true, false] Information whether HTTP Connection should
      #   be closed after processing the request. Happens when HTTP/1.0
      #   or request has Connection=close header.
      def close?
        unsupported_version? || connection_close?
      end

      protected

      # http://en.wikipedia.org/wiki/HTTP_persistent_connection
      def unsupported_version?
        http_version != 'HTTP/1.1'
      end

      def connection_close?
        headers['Connection'] == 'close'
      end

    end

  end
end
