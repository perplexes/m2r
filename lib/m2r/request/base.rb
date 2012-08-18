module M2R
  module Base
    def body_io
      @body_io ||= begin
        b = StringIO.new(body)
        b.set_encoding(Encoding::BINARY)
        b
      end
    end
  end
end

