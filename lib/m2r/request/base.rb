module M2R
  # Logic for typical Mongrel2 request with no fancy features such as
  # async upload
  #
  # @private
  module Base
    MONGREL2_BASE_HEADERS = %w(pattern method path query).map(&:freeze).freeze

    # @return [StringIO] Request body encapsulated in IO compatible object
    # @api public
    def body_io
      @body_io ||= begin
        b = StringIO.new(body)
        b.set_encoding(Encoding::BINARY) if b.respond_to?(:set_encoding)
        b
      end
    end

    protected

    def mongrel_headers
      MONGREL2_BASE_HEADERS
    end

  end
end

