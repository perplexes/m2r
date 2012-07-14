require 'm2r/response'
require 'm2r/response/length'

module M2R
  class Response
    class Ok < Response
      include Length

      def initialize(headers = {}, body)
        super(200, headers, body)
      end
    end
  end
end
