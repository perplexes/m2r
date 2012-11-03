module M2R
  # Logic for Mongrel2 request delivered using async-upload feature
  # Contains methods for recognizing such requests and reading them.
  # @private
  module Upload
    # @return [true,false] True if this is async-upload related request
    # @api public
    def upload?
      !!@mongrel_headers['x-mongrel2-upload-start']
    end

    # @return [true,false] True if this is async-upload start notification
    # @api public
    def upload_start?
      upload? and not upload_path
    end

    # @return [true,false] True if this is final async-upload request
    # @api public
    def upload_done?
      upload? and upload_path
    end

    # @return [String] Relative path to file containing body of HTTP
    #   request.
    # @api public
    def upload_path
      @mongrel_headers['x-mongrel2-upload-done']
    end

    # @return [File] Request body encapsulated in IO compatible object
    # @api public
    def body_io
      return super unless upload_done?
      @body_io ||= begin
        f = File.open(upload_path, "r+b")
        f.set_encoding(Encoding::BINARY) if f.respond_to?(:set_encoding)
        f
      end
    end

    # @return [nil] Free external resources such as files or sockets
    # @api public
    def free!
      super
      File.delete(body_io.path) if upload_done?
    end
  end
end

