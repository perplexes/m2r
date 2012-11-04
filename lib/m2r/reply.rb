require 'm2r/response'
require 'm2r/response/content_length'
require 'm2r/response/to_request'

module M2R
  # Response object to be used without any other framework
  # doing the job of handling content lenght and dealing with
  # 'Connection' header.
  #
  # @api public
  class Reply < Response
    include Response::ContentLength
    include Response::ToRequest
  end
end
