require 'rack/handler'
require 'm2r/rack_handler'
require 'securerandom'
require 'ostruct'

module Rack
  module Handler
    class Mongrel2
      DEFAULT_OPTIONS = {
        'recv_addr' => 'tcp://127.0.0.1:9997',
        'send_addr' => 'tcp://127.0.0.1:9996',
        'sender_id' => SecureRandom.uuid
      }

      def self.run(app, options = {})
        options = OpenStruct.new( DEFAULT_OPTIONS.merge(options) )
        parser  = M2R::Request
        adapter = M2R::RackHandler.new(app, connection_factory(options), parser)
        adapter.listen
      end

      def self.valid_options
        {
          'recv_addr=RECV_ADDR' => 'Receive address',
          'send_addr=SEND_ADDR' => 'Send address',
          'sender_id=UUID'      => 'Sender UUID'
        }
      end

      def self.connection_factory(options)
        klass = if custom = options.connection_factory
          begin
            M2R::ConnectionFactory.const_get(custom.classify)
          rescue NameError
            require "m2r/connection_factory/#{custom.underscore}"
            M2R::ConnectionFactory.const_get(custom.classify)
          end
        else
          M2R::ConnectionFactory
        end
        klass.new(options)
      end
    end

    register :mongrel2, ::Rack::Handler::Mongrel2
  end
end
