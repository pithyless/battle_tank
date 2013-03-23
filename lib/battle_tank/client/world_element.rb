require 'battle_tank/config_loader'

module BattleTank
  class Client
    class WorldElement
      def initialize(model)
        @model = model
        @definition = BattleTank::ConfigLoader.new.elements(model)
      end

      attr_accessor :x, :y, :width, :height

      def width
        if show.kind_of?(String)
          show.length
        elsif show.kind_of?(Array)
          show.first.length
        end
      end

      def height
        if show.kind_of?(String)
          1
        elsif show.kind_of?(Array)
          show.length
        end
      end

      def show
        definition
      end

      def to_h
        {
          "type" => "element",
          "model" => model,
          "x" => x,
          "y" => y
        }
      end

      def self.from_hash(hash)
        BattleTank::Client::WorldElement.new(hash['model']).tap do |elem|
          elem.x = hash['x']
          elem.y = hash['y']
        end
      end

      private

      attr_reader :definition, :model
    end
  end
end
