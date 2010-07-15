# On OSX:
# sudo port install zmq
# sudo gem install zmq
# RUBY_ENGINE = 'ruby'
require 'rubygems'
gem 'ffi-rzmq'
gem 'json'
require 'ffi-rzmq'
require 'json'
$: << File.dirname(__FILE__)
require 'request'

CTX = ZMQ::Context.new(1)
HTTP_FORMAT = "HTTP/1.1 %(code)s %(status)s\r\n%(headers)s\r\n\r\n%(body)s"

class String
  # Match python's % function
  def |(args)
    args.inject(self.dup) do |copy, (key, val)|
      copy.gsub!(/%\(#{key.to_s}\)/, val.to_s)
      copy
    end
  end
end

module Mongrel2
  # A Connection object manages the connection between your handler
  # and a Mongrel2 server (or servers).  It can receive raw requests
  # or JSON encoded requests whether from HTTP or MSG request types,
  # and it can send individual responses or batch responses either
  # raw or as JSON.  It also has a way to encode HTTP responses
  # for simplicity since that'll be fairly common.
  class Connection
  
    def initialize(sender_id, sub_addr, pub_addr)
      @sender_id = sender_id

      @reqs = CTX.socket(ZMQ::UPSTREAM)
      @reqs.connect(sub_addr)

      @resp = CTX.socket(ZMQ::PUB)
      @resp.connect(pub_addr)
      @resp.setsockopt(ZMQ::IDENTITY, sender_id)

      @sub_addr = sub_addr
      @pub_addr = pub_addr
    end
  
    # Receives a raw Request object that you
    # can then work with.
    def recv
      Request.parse(@reqs.recv_string(0))
    end

    # Same as regular recv, but assumes the body is JSON and 
    # creates a new attribute named req.data with the decoded
    # payload.  This will throw an error if it is not JSON.
    # 
    # Normally Request just does this if the METHOD is 'JSON'
    # but you can use this to force it for say HTTP requests.
    def recv_json
      self.recv.tap do |req|
        req.data ||= JSON.parse(req.body)
      end
    end
     
    # Raw send to the given connection ID, mostly used 
    # internally.
    def send_resp(conn_id, msg)
      # debugger
      @resp.send_string(conn_id + ' ' + msg, 0)
    end
    
    # Does a reply based on the given Request object and message.
    # This is easier since the req object contains all the info
    # needed to do the proper reply addressing.
    def reply(req, msg)
      self.send_resp(req.conn_id, msg)
    end

    # Same as reply, but tries to convert data to JSON first.
    def reply_json(req, data)
      self.send_resp(req.conn_id, JSON.generate(data))
    end

    # Basic HTTP response mechanism which will take your body,
    # any headers you've made, and encode them so that the 
    # browser gets them.
    def reply_http(req, body, code=200, status="OK", headers={})
      self.reply(req, http_response(body, code, status, headers))
    end

    # This lets you send a single message to many currently
    # connected clients.  There's a MAX_IDENTS that you should
    # not exceed, so chunk your targets as needed.  Each target
    # will receive the message once by Mongrel2, but you don't have
    # to loop which cuts down on reply volume.
    def deliver(idents, data)
      # debugger
      @resp.send_string(idents.join(' ') + ' ' + data, 0)
    end

    # Same as deliver, but converts to JSON first.
    def deliver_json(idents, data)
      self.deliver(idents, JSON.generate(data))
    end
    
    # Same as deliver, but builds an HTTP response, which means, yes,
    # you can reply to multiple connected clients waiting for an HTTP 
    # response from one handler.  Kinda cool.
    def deliver_http(idents, body, code=200, status="OK", headers={})
      self.deliver(idents, http_response(body, code, status, headers))
    end
    
    private
    def http_response(body, code, status, headers)
      payload = {'code' => code, 'status' => status, 'body' => body}
      headers['Content-Length'] = body.size
      payload['headers'] = headers.map{|k, v| "%s: %s" % [k,v]}.join("\r\n")

      HTTP_FORMAT | payload
    end
  end # class Connection
end # mod Mongrel2