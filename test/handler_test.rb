require 'test_helper'

class HandlerTest < MiniTest::Unit::TestCase
  class TestedHandler < M2R::Handler
    attr_reader :called_methods
    def initialize(connection)
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
  end

  def test_lifecycle_for_disconnect
    connection = Class.new do
      def receive
        M2R::Request.new("sender", "conn_id", "/path", {"METHOD" => "JSON"}, '{"type":"disconnect"}')
      end
    end.new

    h = TestedHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :disconnect], h.called_methods
  end

  def test_lifecycle_for_upload_start
    connection = Class.new do
      def reply(*params)
        @replies ||= []
        @replies << params
      end

      def receive
        M2R::Request.new("sender", "conn_id", "/path", {"x-mongrel2-upload-start" => "/tmp/file"}, '')
      end
    end.new

    h = TestedHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :start], h.called_methods
  end

  def test_lifecycle_for_upload_done
    connection = Class.new do
      def reply(*params)
        @replies ||= []
        @replies << params
      end

      def receive
        M2R::Request.new("sender", "conn_id", "/path", {"x-mongrel2-upload-start" => "/tmp/file", "x-mongrel2-upload-done" => "/tmp/file"}, '')
      end
    end.new

    h = TestedHandler.new(connection)
    h.listen
    assert_equal [:wait, :request, :done, :process, :after, :reply], h.called_methods
  end

end

