module M2R
  module Base
    def body_io
      @body_io ||= begin
        b = StringIO.new(body)
        b.set_encoding(Encoding::BINARY) if b.respond_to?(:set_encoding)
        b
      end
    end
  end
end

