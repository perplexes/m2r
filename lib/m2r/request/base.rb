module M2R
  module Base
    def body_io
      io = StringIO.new(body)
      io.set_encoding(Encoding::BINARY) if io.respond_to?(:set_encoding)
      io
    end
  end
end

