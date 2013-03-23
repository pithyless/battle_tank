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
    window.refresh
  end

  def get_key
    window.timeout = -1

    key = window.getch.ord
    key = parse_key(key)

    window.timeout = 0
    key
  end

  def parse_key(ch, prev=[])
    case [ch, prev]
    when [27, []]
      parse_key(window.getch.ord, [27])
    when [91, [27]]
      parse_key(window.getch.ord, [27, 91])
    when [65, [27, 91]]
      :up
    when [66, [27, 91]]
      :down
    when [67, [27, 91]]
      :right
    when [68, [27, 91]]
      :left
    else
      ch.chr
    end
  rescue RangeError
    ' '
  end

  def scroll(x, y)
    newx = view_x + x
    newy = view_y + y

    newx = [ [0, newx].max, world.width-1 ].min
    newy = [ [0, newy].max, world.height-1 ].min

    @view_x = newx
    @view_y = newy
  end
end
