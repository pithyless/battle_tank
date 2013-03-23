require 'battle_tank/world'
require 'battle_tank/view_port'
require 'battle_tank/control'
require 'battle_tank/client/tank'

world = World.new(500, 500)
view = ViewPort.new(world, 100, 100)

control = Control.new(view)

control.view_loop
control.input_loop
control.until_quit
