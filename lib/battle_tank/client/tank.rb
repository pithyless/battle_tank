require 'battle_tank/config_loader'

module BattleTank
  class Client
    class Tank
      def initialize(model)
        @model = model
        @definition = BattleTank::ConfigLoader.new.tank(model)
        direction = :up
      end

      attr_accessor :x, :y, :width, :height, :direction

      def width
        show.first.length
      end

      def height
        show.length
      end

      def show
        definition['model']["#{direction.to_s}"]
      end

      def bullet
        definition['bullet']
      end

      def to_h
        {
          "type" => "tank",
          "model" => model,
          "x" => x,
          "y" => y,
          "dir" => direction.to_s
        }
      end

      def self.from_hash(hash)
        BattleTank::Client::Tank.new(hash['model']).tap do |tank|
          tank.direction = hash['dir'].to_sym
          tank.x = hash['x']
          tank.y = hash['y']
        end
      end

      private

      attr_reader :definition, :model
    end
  end
end
