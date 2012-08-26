m2r
===

A [Mongrel2](http://mongrel2.org/) backend handler written in Ruby. Also includes Rack adpater to get you up and running quickly.


[![Build Status](https://secure.travis-ci.org/perplexes/m2r.png)](http://travis-ci.org/perplexes/m2r) [![Dependency Status](https://gemnasium.com/perplexes/m2r.png)](https://gemnasium.com/perplexes/m2r)

Installation
------------

You'll need following prerequisites first:

* [Mongrel2](http://mongrel2.org/downloads)
* [ØMQ](http://www.zeromq.org/area:download)

Next, in your `Gemfile` add:

```ruby
gem 'm2r'
```

And finally run:

```
bundle install
```

Guides
------

### Running Rack Application

#### Gemfile

Add `m2r` to `Gemfile` and run `bundle install`

#### Mongrel 2

[Configure `Handler`](http://mongrel2.org/static/book-finalch4.html#x6-260003.4) for your application:

```
rack_example = Handler(
  send_spec  = "tcp://127.0.0.1:9997",
  send_ident = "14fff75f-3474-4089-af6d-bbd67735ab89",
  recv_spec  = "tcp://127.0.0.1:9996",
  recv_ident = ""
)
```

#### Start

```bash
[bundle exec] rackup -s mongrel2 application.ru
```

Add `-O option_name` to provide options for m2r handler:

```ruby
[bundle exec] rackup -s mongrel2 another.ru -O recv_addr=tcp://127.0.0.1:9995 -O send_addr=tcp://127.0.0.1:9994
```

#### Options

* `recv_addr` - This is the `send_spec` option from `Handler` configuration in `mongrel2.conf`. Default: `tcp://127.0.0.1:9997`
* `send_addr` - This is the `recv_sped` option from `Handler` configuration in your `mongrel2.conf`. Default: `tcp://127.0.0.1:9996`

### Developing custom bare Handler

TBD

Versioning
----------

Starting from version `0.1.0` this gem follows [semantic versioning](http://semver.org) policy.

Usage/Examples
-----

* [examples/http\_0mq.rb](https://github.com/perplexes/m2r/blob/master/example/http_0mq.rb) is a test little servlet thing (based on what comes with mongrel2)
* [examples/lobster.ru](https://github.com/perplexes/m2r/blob/master/example/lobster.ru) is a rackup file using the Rack handler that'll serve Rack's funny little lobster app


Contributing
------------

In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing tests
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][]
* by reviewing patches

[issues]: https://github.com/perplexes/m2r/issues

[Read Contributing page](https://github.com/perplexes/m2r/wiki/Contributing) before sending Pull Request :)

Submitting an Issue
-------------------

We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing tests.

[gist]: https://gist.github.com/

Submitting a Pull Request
-------------------------
0. [Read Contributing page](https://github.com/perplexes/m2r/wiki/Contributing)
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add tests for your unimplemented feature or bug fix.
4. Run `bundle exec rake`. If your test pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake`. If your tests fail, return to step 5.
7. Add, commit, and push your changes.
8. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/


Supported Ruby Versions
-----------------------

This library aims to support and is [tested against](http://travis-ci.org/perplexes/m2r) the following Ruby implementations:

- Ruby 1.9.2
- Ruby 1.9.3
- JRuby
- Rubinius

