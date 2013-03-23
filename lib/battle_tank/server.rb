require 'ffi-rzmq'

module BattleTank
  class Server

    WAIT_TIME = 0.2

    def initialize
      init_pull_socket
    end

    attr_reader :pull_socket, :context

    def init_pull_socket
      context = ZMQ::Context.new

      pull_socket = context.socket(ZMQ::PULL)

      rc = pull_socket.setsockopt(ZMQ::LINGER, 0)
      raise "Pull socket failed to set LINGER!" unless ZMQ::Util.resultcode_ok?(rc)

      transport = "tcp://*:5560"
      rc = pull_socket.bind(transport)
      raise "Pull socket could not bind!" unless ZMQ::Util.resultcode_ok?(rc)

      @pull_socket = pull_socket
      @context = context
      p 'Waiting...'
    end

    def handle_requests
      # Let's use GIL to our advantage! mwahahaha...
      queue = []

      receiver = Thread.new do
        loop do
          string = ''
          rc = pull_socket.recv_string(string)
          raise "PULL socket returned errno [#{ZMQ::Util.errno}], msg [#{ZMQ::Util.error_string}]" unless ZMQ::Util.resultcode_ok?(rc)

          queue << string.dup
        end
      end

      loop do
        sleep (WAIT_TIME)

        next if queue.empty?
        puts "\n\n"
        p queue
        queue = []
      end
    end

    def close
      p 'exiting'
      pull_socket.close
      context.terminate
    end

  end
end
