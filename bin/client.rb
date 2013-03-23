require 'battle_tank/world'
require 'battle_tank/view_port'

world = World.new(500, 500)
view = ViewPort.new(world, 100, 100)

world.add(5, 10, 'hello')
view.refresh

view.confirm

# view.scroll(3, 3)
# view.refresh
# view.confirm

world.add(1, 5, 'goodbye')
view.refresh

view.confirm

world.add(5, 10, '      ')
view.refresh

view.confirm
