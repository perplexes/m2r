require 'm2r/connection'
require 'rack'
require 'stringio'
require 'securerandom'

module Rack
  module Handler
    class Mongrel2
      def self.run(app, receive = "tcp://127.0.0.1:9997", send = "tcp://127.0.0.1:9996")
        connection = M2R::Connection.new(SecureRandom.uuid, receive, send)
        @running   = true
        trap("SIGINT") { @running = false }

        while @running
          puts "WAITING FOR REQUEST"

          req = connection.receive
          if req.disconnect?
            puts "DICONNECT"
            next
          end

          script_name = ENV["RACK_RELATIVE_URL_ROOT"] ||
            # PATTERN is like:  /test/(.*.json) or /handlertest
            req.headers["PATTERN"].split('(', 2).first.gsub(/\/$/, '')

          env = {
            "rack.version"      => Rack::VERSION,
            "rack.url_scheme"   => "http",
            "rack.input"        => StringIO.new(req.body),
            "rack.errors"       => $stderr,
            "rack.multithread"  => true,
            "rack.multiprocess" => true,
            "rack.run_once"     => false,
            "mongrel2.pattern"  => req.headers["PATTERN"],
            "REQUEST_METHOD"    => req.headers["METHOD"],
            "SCRIPT_NAME"       => script_name,
            "PATH_INFO"         => req.headers["PATH"].gsub(script_name, ''),
            "QUERY_STRING"      => req.headers["QUERY"]
          }

          env["SERVER_NAME"], env["SERVER_PORT"] = req.headers["host"].split(':', 2)
          req.headers.each do |key, val|
            unless key =~ /content_(type|length)/i
              key = "HTTP_#{key.upcase}"
            end
            env[key] = val
          end

          status, headers, rack_response = app.call(env)
          body = ""
          rack_response.each{|b| body << b}
          connection.reply_http(req, body, status, headers)
        end
      end
    end
  end
end
