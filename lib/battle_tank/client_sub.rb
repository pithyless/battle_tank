$DEBUG = true

require 'ffi-rzmq'
require 'securerandom'

module BattleTank
  class ClientSub

    def initialize(handler)
      @id = SecureRandom.hex
      @handler = handler
      init_sub_socket
    end

    attr_reader :id, :context, :sub_socket, :handler

    def init_sub_socket
      context = ZMQ::Context.new

      sub_socket = context.socket(ZMQ::SUB)

      rc = sub_socket.setsockopt(ZMQ::LINGER, 0)
      rc = sub_socket.setsockopt(ZMQ::SUBSCRIBE, '')
      raise "sub socket failed to set LINGER!" unless ZMQ::Util.resultcode_ok?(rc)

      transport = "tcp://172.17.66.167:5770"
      rc = sub_socket.connect(transport)
      raise "sub socket could not connect!" unless ZMQ::Util.resultcode_ok?(rc)

      sleep 1 # really give the sockets a chance to establish link

      @sub_socket = sub_socket
      @context = context
    end

    def handle_requests
      while true do

        string = ''
        rc = sub_socket.recv_string(string)
        raise "SUB socket returned errno [#{ZMQ::Util.errno}], msg [#{ZMQ::Util.error_string}]" unless ZMQ::Util.resultcode_ok?(rc)

        handler.do_action(string.dup)

        sleep 0.1
      end
    end

    def close
      p 'exiting'
      sub_socket.close
      context.terminate
    end

  end
end
