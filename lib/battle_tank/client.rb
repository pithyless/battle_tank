require 'ffi-rzmq'

module BattleTank
  class Client

    def initialize(name)
      init_push_socket
      @name = name
    end

    attr_reader :name, :context, :push_socket

    def send(msg)
      packet = "Client[#{name}]: #{msg}"

      puts "Sending => #{packet}\n"
      rc = push_socket.send_string(packet)
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
      puts "Client[#{name}]: exiting..."
      push_socket.close
      context.terminate
    end

  end
end
