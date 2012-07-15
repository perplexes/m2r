# An example handler from the Mongrel2 manual. You can spin up many
# of these, Mongrel2 will then round-robin requests to each one.
#
# Running this example:
#
#   bundle exec ruby -I../lib http_0mq.rb
#
#   m2sh load -config mongrel2.conf
#   m2sh start -name main
#
#   curl http://localhost:6767

require 'm2r'
require 'securerandom'

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
HEADERS: #{MultiJson.dump(request.headers, :pretty => true)}
BODY:    #{request.body.inspect}
</pre>
EOF
    response = M2R::Response.new(200, {}, body)
    response.extend(M2R::Response::ContentLength)
    return response
  end
end

sender_id = SecureRandom.uuid
pull_port = "tcp://127.0.0.1:9997"
pub_port  = "tcp://127.0.0.1:9996"

handler   = Http0MQHandler.for(sender_id, pull_port, pub_port)
handler.listen

