module M2R
  class Request
    module Upload
      StartHeader = "x-mongrel2-upload-start".freeze
      DoneHeader  = "x-mongrel2-upload-done".freeze

      def upload?
        headers.key?(upload_start_header)
      end

      def upload_start?
        upload? && !headers.key?(upload_done_header)
      end

      def upload_done?
        upload? && headers.key?(upload_done_header)
      end

      def upload_path
        headers[upload_done_header]
      end

      protected

      def upload_done_header
        Upload::DoneHeader
      end

      def upload_start_header
        Upload::StartHeader
      end
    end
  end
end

