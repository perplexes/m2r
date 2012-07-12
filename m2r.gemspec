# -*- encoding: utf-8 -*-
require File.expand_path('../lib/m2r/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors          = ["Colin Curtin", "Pradeep Elankumaran"]
  gem.email            = ["colin.t.curtin+m2r@gmail.com"]
  gem.description      = "A Mongrel2 interface and handler library for JRuby, and hopefully other Ruby implementations in the future. Works with Rack, so it works with Rails! (Rails installation guide forthcoming)."
  gem.homepage         = "http://github.com/perplexes/m2r"
  gem.summary          = "Mongrel2 interface and handler library for JRuby."
  gem.license          = "MIT"

  gem.files            = Dir.glob("{lib,example,test}/**/*") + %w(LICENSE README.md Rakefile Gemfile m2r.gemspec)
  gem.test_files       = Dir.glob("test/**/*")
  gem.extra_rdoc_files = ["LICENSE", "README.md" ]

  gem.name             = "m2r"
  gem.date             = "2010-10-23"
  gem.require_path     = "lib"
  gem.version          = Mongrel2::VERSION

  gem.add_dependency "ffi-rzmq", "~> 0.9.3"
  gem.add_dependency "ffi",      ">= 1.0.0"
  gem.add_dependency "json"

  gem.add_development_dependency("rake", [">= 0.9.2"])
  gem.add_development_dependency "minitest"

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.authors = ["Colin Curtin", "Pradeep Elankumaran"]
  gem.date = %q{2010-10-23}
  gem.description = %q{A Mongrel2 interface and handler library for JRuby, and hopefully other Ruby implementations in the future. Works with Rack, so it works with Rails! (Rails installation guide forthcoming.)}
  gem.email = %q{colin.t.curtin+m2r@gmail.com}
  gem.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  gem.files = [
    ".document",
     ".gitignore",
     "ISSUES",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "benchmarks/jruby",
     "example/http_0mq.rb",
     "example/lobster.ru",
     "example/rack_handler.rb",
     "lib/connection.rb",
     "lib/fiber_handler.rb",
     "lib/handler.rb",
     "lib/m2r.rb",
     "lib/request.rb",
     "m2r.gemspec",
     "test/helper.rb",
     "test/test_m2r.rb"
  ]
  gem.homepage = %q{http://github.com/perplexes/m2r}
  gem.rdoc_options = ["--charset=UTF-8"]
  gem.require_paths = ["lib"]
  gem.rubygems_version = %q{1.3.6}
  gem.summary = %q{Mongrel2 interface and handler library for JRuby}
  gem.test_files = [
    "test/helper.rb",
    "test/test_m2r.rb",
    "test/test_connection.rb"
  ]

end
