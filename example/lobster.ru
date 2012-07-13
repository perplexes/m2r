# An example of running Rack application.
#
# Running this example:
#
#   bundle exec rackup -I../lib lobster.ru
#
#   m2sh load -config mongrel2.conf
#   m2sh start -name main
#
#   curl http://localhost:6767

require 'rack/lobster'
require './rack_handler'

use Rack::ShowExceptions
Rack::Handler::Mongrel2.run Rack::Lobster.new

