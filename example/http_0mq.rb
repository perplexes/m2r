# An example handler from the Mongrel2 manual. You can spin up many
# of these, Mongrel2 will then round-robin requests to each one.
#
# Running this example:
#
#   m2sh load -config mongrel2.conf
#   bundle exec foreman start
#
# Browse now to http://localhost:6767/handler to see the effect.

$stdout.sync = true
$stderr.sync = true

require 'm2r'

class Http0MQHandler < M2R::Handler
  def on_wait
    puts "WAITING FOR REQUEST"
  end

  def on_disconnect(request)
    puts "DISCONNECT"
  end

  def process(request)
    body = <<EOF
<pre>
SENDER:  #{request.sender}
IDENT:   #{request.conn_id}
PATH:    #{request.path}
HEADERS: #{MultiJson.dump(request.headers.inject({}) {|hash,(h,v)| hash[h]=v; hash }, :pretty => true)}
PATTERN: #{request.pattern}
METHOD:  #{request.method}
QUERY:   #{request.query}
SCHEME:  #{request.scheme}
BODY:    #{request.body.inspect}
</pre>
EOF
    response = M2R::Response.new(200, {}, body)
    response.extend(M2R::Response::ContentLength)
    return response
  end
end

sender_id = "34f9ceee-cd52-4b7f-b197-88bf2f0ec378"
pull_port = "tcp://127.0.0.1:9999"
pub_port  = "tcp://127.0.0.1:9998"

handler   = Http0MQHandler.new(M2R::ConnectionFactory.new(sender_id, pull_port, pub_port), M2R::Request)
handler.listen

