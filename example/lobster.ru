require 'rack/lobster'
$: << File.dirname(__FILE__)
require 'rack_handler'

use Rack::ShowExceptions
puts "Lobster at http://localhost:6767/handlertest"
Rack::Handler::Mongrel2Handler.run Rack::Lobster.new