require 'm2r/response'

module M2R
  class Response
    # Use to disable persisent connections even though
    # your client would prefer otherwise.
    #
    # @api public
    module AlwaysClose
      def close?
        true
      end

      def headers(value = GETTER)
        if value == GETTER
          h = super
          h['Connection'] = 'close'
          h
        else
          super
        end
      end
    end
  end
end

