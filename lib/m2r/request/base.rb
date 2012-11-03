module M2R
  # Logic for typical Mongrel2 request with no fancy features such as
  # async upload
  #
  # @private
  module Base
    # @return [StringIO] Request body encapsulated in IO compatible object
    # @api public
    def body_io
      @body_io ||= begin
        b = StringIO.new(body)
        b.set_encoding(Encoding::BINARY) if b.respond_to?(:set_encoding)
        b
      end
    end

    # @return [nil] Free external resources such as files or sockets
    # @api public
    def free!
      body_io.close
    end

  end
end

