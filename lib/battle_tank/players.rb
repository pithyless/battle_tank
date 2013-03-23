module BattleTank
  class Players
    def initialize
      @next_id = 0
    end

    def add_player(client_id)
      @next_id += 1
      tanks.merge!({"#{next_id}" => gen_tank})
      clients.merge!({client_id => next_id.to_s})
      @next_id.to_s
    end

    def player_tank_id(client_id)
      clients.fetch(client_id)
    end

    def clients
      @client ||= {}
    end

    def tanks
      @tanks ||= {}
    end

    private

    attr_accessor :next_id

    def tank_models
      ['cannon', 'engineer', 'light', 'heavy', 'miner', 'medium']
    end

    def rand_tank_model
      tank_models[rand(tank_models.length)]
    end

    def gen_tank
      BattleTank::Client::Tank.new(rand_tank_model).tap do |t|
        t.x = next_id + 7 ; t.y = next_id + 7;
      end
    end
  end
end
