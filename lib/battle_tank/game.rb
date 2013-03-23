require 'delegate'

module BattleTank
  class MainMenuState
    def initialize
      menu = Menu.new({
        text: 'Start new server',
        action: -> {}
      })
      view = MenuView.new(menu)
      @control = MenuControl.new(view)
    end

    def start
      @control.start
    end

    def update
    end 
  end
  class Menu < SimpleDelegator
    MenuItem = Struct.new(:text, :selected, :action)

    def initialie(items)
      @items = items.map { |item| MenuItem.new(item[:text], item[:action], false) }
      @items.first.selected = true
      super(@items)
    end

    def select_next
      @items[current_selection].selected = false
      current_selection = (current_selection + 1) % @items.count 
      @items[]
    end

    def select_previous
      @items[current_selection].selected = false
      current_selection = (current_selection - 1) % @items.count 
    end

    def selected_item
      @items[current_selection]
    end
  end

end
