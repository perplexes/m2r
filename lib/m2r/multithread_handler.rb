module M2R
  class MultithreadHandler

    attr_reader :threads

    def initialize(singlethread_handler_factory)
      @singlethread_handler_factory = singlethread_handler_factory
    end

    def listen
      @threads = 8.times.map do
        Thread.new do
          handler = @singlethread_handler_factory.new
          Thread.current[:m2r_handler] = handler
          handler.listen
        end
      end
    end

    def stop
      @threads.each do |t|
        t[:m2r_handler].stop
      end
    end

  end
end
