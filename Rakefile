require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "m2r"
    gem.summary = "Mongrel2 interface and handler library for JRuby" 
    gem.description = "A Mongrel2 interface and handler library for JRuby, and hopefully other Ruby implementations in the future. Works with Rack, so it works with Rails! (Rails installation guide forthcoming.)"
    gem.homepage = "http://github.com/perplexes/m2r"
    gem.add_dependency "ffi", ">= 0"
    gem.add_dependency "ffi-rzmq", ">= 0"
    gem.add_dependency "json", ">= 0"
    gem.authors = ["Colin Curtin", "Pradeep Elankumaran"]
    gem.email = "colin.t.curtin+m2r@gmail.com"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "m2r #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
