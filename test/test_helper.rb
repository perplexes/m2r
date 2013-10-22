require 'minitest/autorun'
require 'mocha/setup'
require 'm2r'

Dir[File.expand_path(File.join(__FILE__, '../support/*.rb'))].each { |m| require m }
