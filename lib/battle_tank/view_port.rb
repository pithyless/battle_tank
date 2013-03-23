require 'curses'

class ViewPort
  def initialize(world, width, height)
    @world, @width, @height = world, width, height
    @view_x, @view_y = 0, 0
    init_curses
  end

  attr_reader :world, :width, :height, :view_x, :view_y

  def init_curses
    Curses.init_screen
    Curses.cbreak
    Curses.noecho
    Curses.curs_set(0)
    Curses.timeout = 0
  end

  def window
    @window ||= Curses::Window.new(height, width, 0, 0).tap do |win|
      win.timeout = 0
    end
  end

  def refresh
    world.coords.each_with_index do |row, y|
      next if y < view_y

      window.setpos(y - view_y, 0)
      viewable_row = row[view_x..width]
      window.addstr(viewable_row)
    end
    Curses.doupdate
  end

  def confirm
    window.timeout = -1
    window.getch
    window.timeout = 0
  end

  def scroll(x, y)
    @view_x += x
    @view_y += y

    # TODO: max borders
  end
end
