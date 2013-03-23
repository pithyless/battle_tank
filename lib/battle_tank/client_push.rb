require 'ffi-rzmq'
require 'bert'

module BattleTank
  class ClientPush

    def initialize(client_id)
      init_push_socket
      @client_id = client_id
    end

    attr_reader :client_id, :context, :push_socket

    def send(data)
      rc = push_socket.send_string(BERT.encode(data.merge(client_id: client_id)))
      unless ZMQ::Util.resultcode_ok?(rc)
        STDERR.print("PUSH socket returned errno [#{ZMQ::Util.errno}], msg [#{ZMQ::Util.error_string}]")
        exit!
      end
    end

    def init_push_socket
      context = ZMQ::Context.new(1)

      push_socket = context.socket(ZMQ::PUSH)

      rc = push_socket.setsockopt(ZMQ::LINGER, 1000)
      raise "Push socket failed to set LINGER!" unless ZMQ::Util.resultcode_ok?(rc)

      transport = "tcp://127.0.0.1:5560"
      rc = push_socket.connect(transport)
      raise "Push socket could not connect!" unless ZMQ::Util.resultcode_ok?(rc)

      sleep 1 # really give the sockets a chance to establish link
      @context = context
      @push_socket = push_socket
    end

    def close
      puts "Client[#{client_id}]: exiting..."
      push_socket.close
      context.terminate
    end

  end
end
