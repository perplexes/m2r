m2r
===

A [mongrel2](http://mongrel2.org/index) backend handler written in Ruby, based on [Zed's Python backend handler](http://mongrel2.org/dir?ci=1bdfff8f050b97df&name=examples/python/mongrel2).


[![Build Status](https://secure.travis-ci.org/perplexes/m2r.png)](http://travis-ci.org/perplexes/m2r) [![Dependency Status](https://gemnasium.com/perplexes/m2r.png)](https://gemnasium.com/perplexes/m2r)

Usage/Examples
-----

* `examples/http_0mq.rb` is a test little servlet thing (based on what comes with mongrel2).
* `examples/rack_handler.rb` is a Mongrel2 ruby handler rack handler mouthful, whose variables are probably a little off.
* `examples/lobster.ru` is a rackup file using the Rack handler that'll serve Rack's funny little lobster app.

Running Examples
----------------

* `ruby examples/http_0mq.rb`, which with Mongrel2's test config will serve up at http://localhost:6767/handlertest
* `rackup examples/lobster.ru`, ditto, http://localhost:6767/handlertest

With rails3:
Add this to your Gemfile:

    gem 'ffi'
    gem 'ffi-rzmq'
    gem 'json'

And this to your config.ru:

    $: << location_to_m2r + '/example'
    require 'rack_handler'

    Rack::Handler::Mongrel2.run YourRailsAppName::Application

Then do all like `bundle exec rackup`

Installation
------------

* JRuby 1.5+ (don't use MRI - it will crash horribly, check the ISSUES file)
* [FFI](http://github.com/ffi/ffi), `gem install ffi` should be fine.
* [Zero MQ](http://www.zeromq.org/area:download), you'll need to compile and install to get the headers and such for:
* [ffi-rzmq](http://github.com/chuckremes/ffi-rzmq), which you'll have to build. The native zmq didn't work for me, but if you want to fix it, please do!
* [json](http://github.com/genki/json), since the headers are returned in JSON, which is RAD. (Really Awesome, Dude)
* Rack `gem install rack` if you want to run the rack example.

Contributing
------------

Once you've made your great commits:

1. Fork m2r
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Send a pull request


