require 'battle_tank/world'
require 'battle_tank/view_port'
require 'battle_tank/control'
require 'battle_tank/client/tank'

world = World.new(500, 500)
view = ViewPort.new(world, 100, 100)

control = Control.new(view)

t = BattleTank::Client::Tank.new('jojo', "cannon")
t.direction(:left)
#world.add(5, 10, t.show)
#world.add(1, 5, 'goodbye')

control.view_loop
control.input_loop
control.until_quit
