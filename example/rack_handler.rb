require 'rubygems'
require 'rack'
require 'stringio'
# require 'ruby-debug'
# Debugger.start
# gem install ruby-debug19 -- --with-ruby-include=$HOME/.rvm/src/ruby-1.9.2-head

$: << File.expand_path(File.dirname(__FILE__) + '/..')
require 'connection'

$sender_id = "70D107AB-19F5-44AE-A2D0-2326A167D8D7"

module Rack
  module Handler
    class Mongrel2Handler
      def self.run(app, receive = "tcp://127.0.0.1:9997", send = "tcp://127.0.0.1:9996")
        conn = Mongrel2::Connection.new($sender_id, receive, send)
        while true
          puts "WAITING FOR REQUEST"

          req = conn.recv

          if req.is_disconnect
            puts "DICONNECT"
            next
          end
          
          env = {
            "rack.version" => Rack::VERSION,
            "rack.url_scheme" => "http",
            "rack.input" => StringIO.new(req.body),
            "rack.errors" => $stderr,
            "rack.multithread" => true,
            "rack.multiprocess" => true,
            "rack.run_once" => false,
            "REQUEST_METHOD" => req.headers["METHOD"],
            "SCRIPT_NAME" => "",
            "PATH_INFO" => env["PATH"],
            "QUERY_STRING" => env["QUERY"]
          }
          
          env["SERVER_NAME"], env["SERVER_PORT"] = req.headers["Host"].split(':', 2)
          req.headers.each do |key, val|
            unless key =~ /content_(type|length)/i
              key = "HTTP_#{key.upcase}"
            end
            env[key] = val
          end
          
          status, headers, rack_response = app.call(env)
          conn.reply_http(req, rack_response.body.join, status, headers)
        end
      end
    end
  end
end
    