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

task :test => %w(test:unit test:acceptance)
task :default => :test
