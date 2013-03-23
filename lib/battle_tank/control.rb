$DEBUG = true

require 'curses'
require 'bert'
require 'battle_tank/client_sub'

class Control
  def initialize(view_port)
    @view_port = view_port
    init_client_sub
  end

  attr_reader :view_port

  def init_client_sub
    sub = BattleTank::ClientSub.new(self)
    Thread.new do
      sub.handle_requests
    end
  end

  def do_action(action)
    moves = BERT.decode(action).fetch('moves')
    moves.each do |move|
      view_port.world.move(move[:id], move[:x], move[:y])
    end
  end

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
      end
    end
  end

  def until_quit
    @view_loop.join
  end
end
