module M2R
  module Upload
    StartHeader = "x-mongrel2-upload-start".freeze
    DoneHeader  = "x-mongrel2-upload-done".freeze

    def upload?
      mongrel.key?(upload_start_header)
    end

    def upload_start?
      upload? && !mongrel.key?(upload_done_header)
    end

    def upload_done?
      upload? && mongrel.key?(upload_done_header)
    end

    def upload_path
      mongrel[upload_done_header]
    end

    def mongrel_headers
      super + upload_headers
    end

    protected

    def upload_headers
      [upload_done_header, upload_start_header]
    end

    def upload_done_header
      DoneHeader
    end

    def upload_start_header
      StartHeader
    end
  end
end

