# -*- encoding: utf-8 -*-
require File.expand_path('../lib/m2r/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors          = ["Colin Curtin", "Pradeep Elankumaran", "Pawel Pacana", "Robert Pankowecki"]
  gem.email            = ["colin.t.curtin+m2r@gmail.com", "pawel.pacana+m2r@gmail.com", "robert.pankowecki+m2r@gmail.com"]
  gem.description      = "Mongrel2 Rack handler and pure handler. Works with Rack, so it works with Rails!"
  gem.homepage         = "http://github.com/perplexes/m2r"
  gem.summary          = "Mongrel2 interface and handler library for Ruby."
  gem.license          = "MIT"

  gem.files            = `git ls-files`.split($\)
  gem.executables      = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files       = gem.files.grep(%r{^(test|spec|features)/})
  gem.extra_rdoc_files = ["LICENSE", "README.md" ]

  gem.name             = "m2r"
  gem.require_paths    = ["lib"]
  gem.version          = M2R::VERSION

  gem.add_dependency "ffi-rzmq", "~> 0.9.3"
  gem.add_dependency "ffi", ">= 1.0.0"
  gem.add_dependency "multi_json"
  gem.add_dependency "tnetstring"

  gem.add_development_dependency "rack"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest",            "= 3.2.0"
  gem.add_development_dependency "mocha",               "~> 0.12.1"
  gem.add_development_dependency "bbq",                 "= 0.0.4"
  gem.add_development_dependency "capybara-mechanize",  "= 0.3.0"
  gem.add_development_dependency "activesupport",       "~> 3.2.7"
  gem.add_development_dependency "yard",                "~> 0.8.2"
  gem.add_development_dependency "kramdown",            "~> 0.13.7"

end
