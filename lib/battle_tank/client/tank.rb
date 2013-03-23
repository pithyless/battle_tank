require 'battle_tank/config_loader'

module BattleTank
  class Client
    class Tank
      def initialize(model)
        @definition = BattleTank::ConfigLoader.new.tank(model)
        direction(:up)
      end

      attr_accessor :x, :y

      def show
        definition['model']["#{side.to_s}"]
      end

      def direction(side)
        @side = side
      end

      def bullet
        definition['bullet']
      end

      private

      attr_reader :definition, :side
    end
  end
end
