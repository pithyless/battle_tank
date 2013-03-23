# $DEBUG = true
require 'curses'

class Control
  def initialize(view_port)
    @view_port = view_port
  end

  attr_reader :view_port

  def view_loop
    @view_loop = Thread.new do
      while true do
        view_port.refresh
        sleep 0.1
      end
    end
  end

  def input_loop
    @input_loop = Thread.new do
      while true
        c = view_port.get_key
        case c
        when :up
          view_port.scroll(0, -1)
        when :down
          view_port.scroll(0, 1)
        when :left
          view_port.scroll(-1, 0)
        when :right
          view_port.scroll(1, 0)
        end
        view_port.refresh
      end
    end
  end

  def until_quit
    @view_loop.join
  end
end
