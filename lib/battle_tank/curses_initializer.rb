require 'curses'

module BattleTank
  module CursesInitializer
    def self.init
      return if @initialized

      Curses.init_screen
      Curses.cbreak
      Curses.noecho
      Curses.curs_set(0)
      Curses.timeout = 0
      Curses.start_color
      
      @initialized = true
    end
  end
end
