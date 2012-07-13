# -*- encoding: utf-8 -*-
require File.expand_path('../lib/m2r/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors          = ["Colin Curtin", "Pradeep Elankumaran"]
  gem.email            = ["colin.t.curtin+m2r@gmail.com"]
  gem.description      = "A Mongrel2 interface and handler library for JRuby, and hopefully other Ruby implementations in the future. Works with Rack, so it works with Rails! (Rails installation guide forthcoming)."
  gem.homepage         = "http://github.com/perplexes/m2r"
  gem.summary          = "Mongrel2 interface and handler library for JRuby."
  gem.license          = "MIT"

  gem.files            = Dir.glob("{lib,example,test}/**/*") + %w(ISSUES LICENSE README.md Rakefile Gemfile m2r.gemspec)
  gem.test_files       = Dir.glob("test/**/*")
  gem.extra_rdoc_files = ["LICENSE", "README.md" ]

  gem.name             = "m2r"
  gem.date             = "2010-10-23"
  gem.require_path     = "lib"
  gem.version          = Mongrel2::VERSION

  gem.add_dependency "ffi-rzmq", "~> 0.9.3"
  gem.add_dependency "json"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
end
