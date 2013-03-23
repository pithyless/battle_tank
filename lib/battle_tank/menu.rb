require 'delegate'

module BattleTank
  class Menu < SimpleDelegator
    MenuItem = Struct.new(:text, :action, :selected)

    def initialize(items)
      @items = items.map { |item| MenuItem.new(item[:text], item[:action], false) }
      @items.first.selected = true
      @current_selection = 0
      super(@items)
    end

    def select_next
      @items[@current_selection].selected = false
      @current_selection = (@current_selection + 1) % @items.count 
      @items[@current_selection].selected = true
    end

    def select_previous
      @items[@current_selection].selected = false
      @current_selection = (@current_selection - 1) % @items.count 
      @items[@current_selection].selected = true
    end

    def selected_item
      @items[@current_selection]
    end
  end
end
