require 'thread'
require 'm2r/handler'

class TestHandler < M2R::Handler
  attr_reader :called_methods
  def initialize(connection_factory, parser)
    super
    @mutex = Mutex.new
    @called_methods = []
    Thread.current[:called_methods] = []
  end

  def on_wait()
    unless Thread.current[:called_methods].empty?
      stop
      return
    end
    called_method :wait
  end

  def on_request(request)
    called_method :request
  end

  def process(request)
    called_method :process
    return "response"
  end

  def on_disconnect(request)
    called_method :disconnect
  end

  def on_upload_start(request)
    called_method :start
  end

  def on_upload_done(request)
    called_method :done
  end

  def after_process(request, response)
    called_method :after
    return response
  end

  def after_reply(request, response)
    called_method :reply
  end

  def after_all(request, response)
    called_method :all
  end

  def on_error(request, response, error)
    called_method :error
  end

  def on_interrupted
    called_method :interrupted
  end

  private

  def called_method(mth)
    Thread.current[:called_methods] << mth
    @mutex.synchronize do
      @called_methods << mth
    end
  end

end
