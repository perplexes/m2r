require 'm2r/handler'

class TestHandler < M2R::Handler
  attr_reader :called_methods
  def initialize(connection, parser)
    super
    @called_methods = []
  end

  def on_wait()
    unless @called_methods.empty?
      stop
      return
    end
    @called_methods << :wait
  end

  def on_request(request)
    @called_methods << :request
  end

  def process(request)
    @called_methods << :process
    return "response"
  end

  def on_disconnect(request)
    @called_methods << :disconnect
  end

  def on_upload_start(request)
    @called_methods << :start
  end

  def on_upload_done(request)
    @called_methods << :done
  end

  def after_process(request, response)
    @called_methods << :after
    return response
  end

  def after_reply(request, response)
    @called_methods << :reply
  end

  def after_all(request, response)
    @called_methods << :all
  end
end
