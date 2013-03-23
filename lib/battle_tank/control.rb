$DEBUG = true

require 'curses'
require 'bert'
require 'securerandom'
require 'battle_tank/client_sub'
require 'battle_tank/client_push'

class Control
  def initialize(view_port)
    @view_port = view_port
    init_client_sub
  end

  def client_id
    @client_id ||= SecureRandom.hex
  end

  def register_player
    client_push.send({ action: 'new_player' })
    sleep 1
  end

  attr_reader :view_port

  def init_client_sub
    sub = BattleTank::ClientSub.new(self)
    Thread.new do
      sub.handle_requests
    end
  end

  def client_push
    @client_push ||= BattleTank::ClientPush.new(client_id)
  end

  def do_action(data)
    action = BERT.decode(data)
    if action['moves']
      action['moves'].each do |move|
        view_port.world.move(move[:id], move[:x], move[:y], dir: move[:dir])
      end
    elsif action['create']
      action['create'].each do |create|
        view_port.world.objects[create[:id]] = BattleTank::Client::Tank.new('medium') do |t|
          t.x = create[:x]
          t.y = create[:y]
          t.direction = create[:dir]
        end
      end
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
          client_push.send({ action: 'move', dir: :up })
        when :down
          client_push.send({ action: 'move', dir: :down })
        when :left
          client_push.send({ action: 'move', dir: :left })
        when :right
          client_push.send({ action: 'move', dir: :right })
        end
      end
    end
  end

  def until_quit
    @view_loop.join
  end
end
