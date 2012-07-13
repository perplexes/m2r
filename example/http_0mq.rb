# http_0mq.rb - an example handler from the Mongrel2 book
# You can spin up many of these - Mongrel2 will then round-robin requests to each one.

# require 'rubygems'
# require 'ruby-debug'
# Debugger.start
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'm2r'

class Http0MQHandler < Mongrel2::Handler
  # There are more hooks you can override - check out lib/handler.rb

  def on_wait
    puts "WAITING FOR REQUEST"
  end

  def on_disconnect
    puts "DISCONNECT"
  end

  def process(req)
    response = "<pre>\nSENDER: %s\nIDENT:%s\nPATH: %s\nHEADERS:%s\nBODY:%s</pre>" % [
      req.sender.inspect, req.conn_id.inspect, req.path.inspect,
      JSON.generate(req.headers).inspect, req.body.inspect]
    puts response
    response
  end
end

sender_id = "C2256F34-14A1-45DD-BB73-97CAE25E25B4"
handler = Http0MQHandler.new(
            sender_id, "tcp://127.0.0.1:9997", "tcp://127.0.0.1:9996")
handler.listen
