require 'delegate'
require 'battle_tank/menu'
require 'battle_tank/menu_view'
require 'battle_tank/menu_control'
require 'battle_tank/client_state'
require 'battle_tank/server_state'

module BattleTank
  class MainMenuState
    def initialize
      menu = BattleTank::Menu.new([{
        text: 'Start server',
        action: -> do 
          stop
          ServerState.new.start 
      end
      },{
        text: 'Join game',
        action: -> do
         stop
         ClientState.new.start
        end
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

    def stop
      @control.stop
      Curses.clear
    end 
  end
end
