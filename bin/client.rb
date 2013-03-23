require 'battle_tank/world'
require 'battle_tank/view_port'
require 'battle_tank/control'

world = World.new(500, 500)
view = ViewPort.new(world, 100, 100)
control = Control.new(view)

world.add(5, 10, 'hello')
world.add(1, 5, 'goodbye')

control.view_loop
control.input_loop

control.until_quit

# view.scroll(3, 3)
# view.refresh
# view.confirm
