require 'ffi-rzmq'
require 'bert'

module BattleTank
  class ServerPub

    def initialize
      init_pub_socket
    end

    attr_reader :context, :pub_socket

    def broadcast(data)
      rc = pub_socket.send_string(BERT.encode(data))
      unless ZMQ::Util.resultcode_ok?(rc)
        STDERR.print("pub socket returned errno [#{ZMQ::Util.errno}], msg [#{ZMQ::Util.error_string}]")
        exit!
      end
    end

    def init_pub_socket
      context = ZMQ::Context.new(1)

      pub_socket = context.socket(ZMQ::PUB)

      rc = pub_socket.setsockopt(ZMQ::LINGER, 0)
      raise "pub socket failed to set LINGER!" unless ZMQ::Util.resultcode_ok?(rc)

      transport = "tcp://*:5770"
      rc = pub_socket.bind(transport)
      raise "pub socket could not bind!" unless ZMQ::Util.resultcode_ok?(rc)

      @context = context
      @pub_socket = pub_socket
    end

    def close
      puts "ServerPub exiting..."
      pub_socket.close
      context.terminate
    end

  end
end
