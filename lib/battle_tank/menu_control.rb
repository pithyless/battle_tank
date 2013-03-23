module BattleTank
  class MenuControl
    attr_reader :view, :menu

    def initialize(menu, view)
      @menu = menu
      @view = view
    end

    def start
      @running =true
      view.refresh
      input_loop
      input_loop.join
    end

    def stop
      @running = false
    end

    def input_loop
      @input_loop = Thread.new do
        while @running
          c = view.get_key
          case c
          when :down
            menu.select_next
            view.refresh
          when :up
            menu.select_previous
            view.refresh
          when :enter
            menu.selected_item.action.call
          end
        end
      end
    end
  end
end
