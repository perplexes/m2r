# An example of running Rack application.
#
# Running this example:
#
#   m2sh load -config mongrel2.conf
#   bundle exec foreman start
#
# Browse now to http://localhost:6767/rack to see the effect.

$stdout.sync = true
$stderr.sync = true

require 'rack/lobster'
use Rack::ContentLength
run Rack::Lobster.new
