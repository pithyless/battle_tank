require 'battle_tank/curses_initializer'
require 'curses'

module BattleTank
  class MenuView
    WINDOW_COLOR_PAIR = 2
    SELECTED_COLOR_PAIR = 3

    attr_reader :menu
    def initialize(menu, width, height)
      @menu = menu
      @width = width
      @height = height
      BattleTank::CursesInitializer.init
      Curses.init_pair(WINDOW_COLOR_PAIR, Curses::COLOR_YELLOW, Curses::COLOR_BLUE)
      Curses.init_pair(SELECTED_COLOR_PAIR, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
    end

    def window
      @window ||= Curses::Window.new(20, 40, @height/2-10, @width/2-20).tap do |win|
        win.timeout = 0
        win.color_set(WINDOW_COLOR_PAIR)
        win.bkgdset(' '.ord)
        win.box(?|, ?-)
      end
    end

    def refresh
      window.clear
      menu.each_with_index do |item, index|
        window.setpos(2 + index, 2)
        attributes = 
          if item.selected
            Curses.color_pair(SELECTED_COLOR_PAIR) | Curses::A_UNDERLINE
          else
            Curses.color_pair(WINDOW_COLOR_PAIR) | Curses::A_NORMAL
          end
        window.attron(attributes) { window.addstr(item.text) }
      end
      window.refresh
    end

    def get_key
      window.timeout = -1

      key = window.getch
      key = parse_key(key)

      window.timeout = 0
      key
    end

    def parse_key(ch)
      case ch
      when ?A
        :up
      when ?B
        :down
      when 10
        :enter
      end
    end
  end
end
