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
* [ØMQ](http://www.zeromq.org/area:download)

Next, in your `Gemfile` add:

```ruby
gem 'm2r'
```

And finally run:

```
bundle install
```

Versioning
----------

Starting from version `0.1.0` this gem follows [semantic versioning](http://semver.org) policy.

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

