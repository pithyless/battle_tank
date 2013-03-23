require 'battle_tank/server'
require 'battle_tank/server_pub'

#server = BattleTank::Server.new
#
#begin
#  server.handle_requests
#ensure
#  server.close
#end



server = BattleTank::ServerPub.new

begin
  server.broadcast_world
ensure
  server.close
end

