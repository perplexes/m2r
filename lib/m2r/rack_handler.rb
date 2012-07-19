require 'm2r'
require 'rack'

module M2R
  class RackHandler < Handler
    def initialize(app, connection)
      @app = app
      super(connection)

      trap('INT') { stop }
    end

    def process(request)
      headers = request.headers.dup

      pattern, path = headers.delete('PATTERN'), headers.delete('PATH')
      script_name   = pattern.split('(', 2).first.gsub(/\/$/, '')
      path_info     = path.gsub(script_name, '')

      rack_input = StringIO.new(request.body)
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env = {
        'REQUEST_METHOD'    => request.method,
        'SCRIPT_NAME'       => script_name,
        'PATH_INFO'         => path_info,
        'QUERY_STRING'      => headers.delete('QUERY') || "",
        'rack.version'      => ::Rack::VERSION,
        'rack.errors'       => $stderr,
        'rack.multithread'  => false,
        'rack.multiprocess' => true,
        'rack.run_once'     => false,
        'rack.url_scheme'   => https? ? 'https' : 'http',
        'rack.input'        => rack_input,
      }
      env['SERVER_NAME'], env['SERVER_PORT'] = headers['host'].split(':', 2)

      headers.each do |key, val|
        key      = "HTTP_#{key.tr('-', '_').upcase}"
        env[key] = val unless %w(HTTP_CONTENT_LENGTH HTTP_CONTENT_TYPE).include?(key)
      end

      status, headers, body = @app.call(env)
      buffer = ""
      body.each { |part| buffer << part }
      return M2R::Response.new(status, headers, buffer)
    end

    protected

    def https?
      %w(yes on 1).include? ENV['HTTPS']
    end
  end
end
