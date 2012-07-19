module M2R
  module Upload
    MONGREL2_HEADERS = %w(x-mongrel2-upload-start x-mongrel2-upload-done).map(&:freeze).freeze

    def upload?
      !!@mongrel_headers['x-mongrel2-upload-start']
    end

    def upload_start?
      upload? and not upload_path
    end

    def upload_done?
      upload? and upload_path
    end

    def upload_path
      @mongrel_headers['x-mongrel2-upload-done']
    end

    protected

    def mongrel_headers
      (super if defined?(super)).to_a + MONGREL2_HEADERS
    end
  end
end

