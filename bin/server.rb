require 'battle_tank/server'

server = BattleTank::Server.new

begin
  server.handle_requests
ensure
  server.close
end

