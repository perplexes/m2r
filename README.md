m2r
===

A [mongrel2](http://mongrel2.org/index) backend handler written in Ruby, based on [Zed's Python backend handler](http://mongrel2.org/dir?ci=1bdfff8f050b97df&name=examples/python/mongrel2).

Usage/Examples
-----

* `examples/http_0mq.rb` is a test little servlet thing (based on what comes with mongrel2)and there is also a rack handler at 
* `examples/rack_handler.rb` is a Mongrel2 ruby handler rack handler mouthful, whose variables are probably a little off
* `examples/lobster.ru` is a rackup file using the Rack handler that'll serve Rack's funny little lobster app.

Run:
* `ruby examples/http_0mq.rb`, which with Mongrel2's test config will serve up at http://localhost:6767/handlertest
* `rackup examples/lobster.ru`, ditto, http://localhost:6767/handlertest

Installation
------------

* Ruby 1.9ish (RVM saved my life here)
* [FFI](http://github.com/ffi/ffi), `gem install ffi` should be fine
* [Zero MQ](http://www.zeromq.org/area:download)
* [ffi-rzmq](http://github.com/chuckremes/ffi-rzmq), which you'll have to build. The native zmq didn't work for me, but if you want to fix it, please do!
* Rack (gem install rack) if you want to run the rack example.
