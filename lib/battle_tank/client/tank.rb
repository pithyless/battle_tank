module BattleTank
  class Client
    class Tank
      def initialize(name, model)
        @model = model
        @name = name
        build_model
        direction(:up)
      end

      def show
        send("#{side.to_s}_side")
      end

      def direction(side)
        @side = side
      end

      private

      attr_reader :model, :name, :right_side, :left_side, :up_side, :down_side, :bullet_char, :additional_weapon_char, :side

      def map_file
        File.join(File.dirname(__FILE__), '..', '..', '..', 'models', 'tanks', "#{model}.map")
      end

      def build_model
        file = File.open(map_file)
        map = []
        file.each_line do |line|
          map << line.delete("\n")
        end

        @right_side = map[0..2]
        @left_side = map[3..5]
        @up_side = map[6..8]
        @down_side = map[9..11]
        @bullet_char = map[12]
        @additional_weapon_char = map[13]
      end
    end
  end
end