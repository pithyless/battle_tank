require 'battle_tank/config_loader'

module BattleTank
  class Client
    class Bullet
      attr_accessor :x, :y, :width, :height

      def width
        1
      end

      def height
        1
      end

      def show
        'o'
      end

      def direction(side)
        @side = side
      end

      def to_h
        {
          "type" => "bullet",
          'dir' => side.to_s,
          "x" => x,
          "y" => y
        }
      end

      def self.from_hash(hash)
        BattleTank::Client::Bullet.new.tap do |bullet|
          bullet.direction(hash['x'].to_sym)
          bullet.x = hash['x']
          bullet.y = hash['y']
        end
      end

      private

      attr_reader :definition, :model, :side
    end
  end
end
