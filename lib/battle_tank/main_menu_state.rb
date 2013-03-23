require 'delegate'
require 'battle_tank/menu'
require 'battle_tank/menu_view'
require 'battle_tank/menu_control'

module BattleTank
  class MainMenuState
    def initialize
      menu = BattleTank::Menu.new([{
        text: 'Start new game',
        action: -> {}
      },{
        text: 'Join game',
        action: -> {}
      },{
        text: 'Quit',
        action: -> {@control.stop}
      }])
      view = BattleTank::MenuView.new(menu, 60, 20)
      @control = BattleTank::MenuControl.new(menu, view)
    end

    def start
      @control.start
    end

    def update
    end 
  end
end
