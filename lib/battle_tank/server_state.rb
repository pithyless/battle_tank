require 'battle_tank/server'
require 'battle_tank/server_pub'

module BattleTank
  class ServerState
    def start
      server_pub = BattleTank::ServerPub.new

      server = BattleTank::Server.new(server_pub)

      begin
        server.handle_requests
      ensure
        server.close
      end
    end
  end
end
