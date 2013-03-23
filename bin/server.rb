require 'battle_tank/server'
require 'battle_tank/server_pub'


server_pub = BattleTank::ServerPub.new

server = BattleTank::Server.new(server_pub)

begin
  server.handle_requests
ensure
  server.close
end

