#!/usr/bin/env rake

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/test_*.rb'
  test.libs << 'lib' << 'test'
end

task :default => :test
