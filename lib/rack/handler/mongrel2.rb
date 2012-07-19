require 'rack/handler'
require 'm2r/rack_handler'
require 'securerandom'

module Rack
  module Handler
    class Mongrel2
      DEFAULT_OPTIONS = {
        :recv_addr => 'tcp://127.0.0.1:9997',
        :send_addr => 'tcp://127.0.0.1:9996',
        :sender_id => SecureRandom.uuid
      }

      def self.run(app, options = {})
        options    = DEFAULT_OPTIONS.merge(options)
        connection = M2R::Connection.new(options[:sender_id], options[:recv_addr], options[:send_addr])
        adapter    = M2R::RackHandler.new(app, connection)
        adapter.listen
      end

      def self.valid_options
        {
          'recv_addr=RECV_ADDR' => 'Receive address',
          'send_addr=SEND_ADDR' => 'Send address',
          'sender_id=UUID' => 'Sender UUID'
        }
      end
    end

    register :mongrel2, ::Rack::Handler::Mongrel2
  end
end
