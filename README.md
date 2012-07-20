m2r
===

A [Mongrel2](http://mongrel2.org/) backend handler written in Ruby. Also includes Rack adpater to get you up and running quickly.


[![Build Status](https://secure.travis-ci.org/perplexes/m2r.png)](http://travis-ci.org/perplexes/m2r) [![Dependency Status](https://gemnasium.com/perplexes/m2r.png)](https://gemnasium.com/perplexes/m2r)

Usage/Examples
-----

* [examples/http\_0mq.rb](https://github.com/perplexes/m2r/blob/master/example/http_0mq.rb) is a test little servlet thing (based on what comes with mongrel2)
* [examples/lobster.ru](https://github.com/perplexes/m2r/blob/master/example/lobster.ru) is a rackup file using the Rack handler that'll serve Rack's funny little lobster app

Installation
------------

You'll need following prerequisites first:

* [Mongrel2](http://mongrel2.org/downloads)
* [Zero MQ](http://www.zeromq.org/area:download)

Next, in your Gemfile add:

```ruby
gem 'm2r'
```

And finally run:

```
bundle install
```

Contributing
------------

Once you've made your great commits:

1. Fork m2r
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Send a pull request


