#!/usr/bin/env rake

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new('test:unit') do |test|
  test.pattern = 'test/unit/*_test.rb'
  test.libs << 'lib' << 'test'
end

Rake::TestTask.new('test:acceptance') do |test|
  test.pattern = 'test/acceptance/*_test.rb'
  test.libs << 'lib' << 'test'
end

if (ENV['HOME'] =~ /travis/ || ENV['BUNDLE_GEMFILE'] =~ /travis/) && RUBY_ENGINE =~ /jruby|rbx/
  task :test => %w(test:unit)
else
  task :test => %w(test:unit test:acceptance)
end

task :default => :test
