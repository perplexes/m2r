require 'capybara'
require 'capybara/mechanize'

Capybara.app_host = "http://localhost:6767/"
Capybara.current_driver = :mechanize
