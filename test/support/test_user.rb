require 'bbq/test'
require 'bbq/test_user'
require 'support/capybara'

class TestUser < Bbq::TestUser
  include MiniTest::Assertions

  def initialize
    super(:driver => :mechanize)
  end

  def see!(*args)
    msg = "Expected to see %s but not found"
    args.each { |arg| assert has_content?(arg), msg % arg }
  end

  def generate_file
    File.open(@path = "./tmp/#{Time.now.to_i}", "w") do |f|
      f.write SecureRandom.hex(5120)
    end
    file_path
  end

  def attach_first_file(form_id, file_path)
    page.driver.browser.agent.current_page.form_with(id: form_id) do |form|
      form.file_uploads.first.file_name = file_path
    end
  end

  def attach_and_submit_first_file(form_id, file_path)
    attach_first_file(form_id, file_path).submit
  end

  def file_path
    @path
  end
end
