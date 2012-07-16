# An example of running Rack application.
#
# Running this example:
#
#   bundle exec rackup -I../lib -a mongrel2 lobster.ru
#
#   m2sh load -config mongrel2.conf
#   m2sh start -name main
#
#   curl http://localhost:6767

require 'rack/lobster'
use Rack::ContentLength
run Rack::Lobster.new
