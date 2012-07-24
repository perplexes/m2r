require 'm2r'
require 'rack'

module M2R
  class RackHandler < Handler
    attr_accessor :app

    def initialize(app, connection)
      @app = app
      super(connection)

      trap('INT') { stop }
    end

    def self.for(app, sender_uuid, subscribe_address, publish_address)
      new(app, Connection.for(sender_uuid, subscribe_address, publish_address))
    end

    def process(request)
      script_name = request.pattern.split('(', 2).first.gsub(/\/$/, '')

      rack_input = StringIO.new(request.body)
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env = {
        'REQUEST_METHOD'    => request.method,
        'SCRIPT_NAME'       => script_name,
        'PATH_INFO'         => request.path.gsub(script_name, ''),
        'QUERY_STRING'      => request.query || "",
        'rack.version'      => ::Rack::VERSION,
        'rack.errors'       => $stderr,
        'rack.multithread'  => false,
        'rack.multiprocess' => true,
        'rack.run_once'     => false,
        'rack.url_scheme'   => https? ? 'https' : 'http',
        'rack.input'        => rack_input,
      }
      env['SERVER_NAME'], env['SERVER_PORT'] = request.headers['Host'].split(':', 2)
      request.headers.rackify(env)

      status, headers, body = @app.call(env)
      buffer = ""
      body.each { |part| buffer << part }
      return Response.new(status, headers, buffer)
    end

    protected

    def https?
      %w(yes on 1).include? ENV['HTTPS']
    end
  end
end
