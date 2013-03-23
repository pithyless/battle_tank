$DEBUG = true

require 'ffi-rzmq'
require 'battle_tank/client/tank'

module BattleTank
  class Server

    WAIT_TIME = 0.1

    def initialize(server_pub)
      @server_pub = server_pub
      init_pull_socket
    end

    attr_reader :pull_socket, :context, :server_pub

    def players
      @players ||= Players.new
    end

    def broadcast_diff(diffs)
      server_pub.broadcast(diffs)
    end

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
    end

    def make_diff(diffs, data)
      if data[:action] == 'move'
        client_id = data.fetch(:client_id)
        tank_id = player_tank_id(client_id)
        tank = TANKS.fetch(tank_id)
        diffs['moves'] ||= []

        case data.fetch(:dir)
        when :up; tank.y -= 1; tank.direction = :up
        when :down; tank.y += 1; tank.direction = :down
        when :left; tank.x -= 1; tank.direction = :left
        when :right; tank.x += 1; tank.direction = :right
        end

        diffs['moves'] << {id: tank_id, x: tank.x, y: tank.y, dir: tank.direction}
      end
    end

    def handle_requests
      # Let's use GIL to our advantage! mwahahaha...
      diffs = {}

      receiver = Thread.new do
        loop do
          string = ''
          rc = pull_socket.recv_string(string)
          raise "PULL socket returned errno [#{ZMQ::Util.errno}], msg [#{ZMQ::Util.error_string}]" unless ZMQ::Util.resultcode_ok?(rc)
          make_diff(diffs, BERT.decode(string.dup))
        end
      end

      loop do
        sleep (WAIT_TIME)
        next if diffs.empty?

        broadcast_diff(diffs)
        diffs = {}
      end
    end

    def close
      p 'exiting'
      pull_socket.close
      context.terminate
    end

  end
end
