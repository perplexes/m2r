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

module Mongrel2
  # A Connection object manages the connection between your handler
  # and a Mongrel2 server (or servers).  It can receive raw requests
  # or JSON encoded requests whether from HTTP or MSG request types,
  # and it can send individual responses or batch responses either
  # raw or as JSON.  It also has a way to encode HTTP responses
  # for simplicity since that'll be fairly common.
  class Connection

    def initialize(sender_id, sub_addr, pub_addr, context = Mongrel2.zmq_context)
      @sender_id = sender_id

      @reqs = context.socket(ZMQ::PULL)
      @reqs.connect(sub_addr)

      @resp = context.socket(ZMQ::PUB)
      @resp.connect(pub_addr)
      @resp.setsockopt(ZMQ::IDENTITY, sender_id)

      @sub_addr = sub_addr
      @pub_addr = pub_addr
    end

    # Receives a raw Request object that you
    # can then work with.
    def recv
      msg = String.new
      rc = @reqs.recv_string msg, 0
      Request.parse(msg)
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
    def send_resp(uuid, conn_id, msg)
      header = "%s %d:%s," % [uuid, conn_id.size, conn_id]
      string = header + ' ' + msg
      #puts "DEBUG: #{string.inspect}"
      @resp.send_string(string, 0)
    end

    # Does a reply based on the given Request object and message.
    # This is easier since the req object contains all the info
    # needed to do the proper reply addressing.
    def reply(req, msg)
      self.send_resp(req.sender, req.conn_id, msg)
    end

    # Same as reply, but tries to convert data to JSON first.
    def reply_json(req, data)
      self.send_resp(req.sender, req.conn_id, JSON.generate(data))
    end

    # Basic HTTP response mechanism which will take your body,
    # any headers you've made, and encode them so that the
    # browser gets them.
    def reply_http(req, body, code=200, headers={})
      self.reply(req, http_response(body, code, headers))
    end

    # This lets you send a single message to many currently
    # connected clients.  There's a MAX_IDENTS that you should
    # not exceed, so chunk your targets as needed.  Each target
    # will receive the message once by Mongrel2, but you don't have
    # to loop which cuts down on reply volume.
    def deliver(uuid, idents, data)
      self.send_resp(uuid, idents.join(' '), data)
    end

    # Same as deliver, but converts to JSON first.
    def deliver_json(uuid, idents, data)
      self.deliver(uuid, idents, JSON.generate(data))
    end

    # Same as deliver, but builds an HTTP response, which means, yes,
    # you can reply to multiple connected clients waiting for an HTTP
    # response from one handler.  Kinda cool.
    def deliver_http(uuid, idents, body, code=200, headers={})
      self.deliver(uuid, idents, http_response(body, code, headers))
    end

    private
    def http_response(body, code, headers)
      headers['Content-Length'] = body.size
      headers_s = headers.map{|k, v| "%s: %s" % [k,v]}.join("\r\n")

      "HTTP/1.1 #{code} #{StatusMessage[code.to_i]}\r\n#{headers_s}\r\n\r\n#{body}"
    end

    # From WEBrick: thanks dawg.
    StatusMessage = {
      100 => 'Continue',
      101 => 'Switching Protocols',
      200 => 'OK',
      201 => 'Created',
      202 => 'Accepted',
      203 => 'Non-Authoritative Information',
      204 => 'No Content',
      205 => 'Reset Content',
      206 => 'Partial Content',
      300 => 'Multiple Choices',
      301 => 'Moved Permanently',
      302 => 'Found',
      303 => 'See Other',
      304 => 'Not Modified',
      305 => 'Use Proxy',
      307 => 'Temporary Redirect',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      402 => 'Payment Required',
      403 => 'Forbidden',
      404 => 'Not Found',
      405 => 'Method Not Allowed',
      406 => 'Not Acceptable',
      407 => 'Proxy Authentication Required',
      408 => 'Request Timeout',
      409 => 'Conflict',
      410 => 'Gone',
      411 => 'Length Required',
      412 => 'Precondition Failed',
      413 => 'Request Entity Too Large',
      414 => 'Request-URI Too Large',
      415 => 'Unsupported Media Type',
      416 => 'Request Range Not Satisfiable',
      417 => 'Expectation Failed',
      500 => 'Internal Server Error',
      501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
      505 => 'HTTP Version Not Supported'
    }
  end # class Connection
end # mod Mongrel2
