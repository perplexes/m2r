# Running this example:
#
#   m2sh load -config mongrel2.conf
#   bundle exec foreman start
#
# Browse now to http://localhost:6767/uploading to see the effect.
#
# This example is not threadsafe !

require 'rack'
require 'pathname'

use Rack::ContentLength
size = 0
app = Proc.new do |env|
  req = Rack::Request.new(env)
  if req.post?
    size = req.params["file"][:tempfile].size.to_s rescue size = 0
  end
  note = req.post?? "You submitted file of size: #{size}" : "Last submitted file was of size: #{size}"
  body = <<-EOF
    <html>
      <body>
        <form name="uploading" id="uploading_form" method="post" enctype="multipart/form-data" action="/uploading">
          <input type="file" name="file" id="file"></input>
          <input type="submit" name="submit" id="submit">Submit</input>
        </form>
        <p>#{note}</p>
      </body>
    </html>
  EOF
  puts body
  [200, {'Content-Type' => 'text/html'}, [body]]
end
run app
