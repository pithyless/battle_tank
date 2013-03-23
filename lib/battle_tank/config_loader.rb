require "json"
module BattleTank
  class ConfigLoader

    def initialize
      @base_path = File.join(File.dirname(__FILE__), '..', '..')
    end

    def tank(model_name)
      file = File.open(File.join(base_path, 'models', 'tanks', "#{model_name}.json"))
      JSON.parse(file.read)
    end

    def maps(map_name)
      file = File.open(File.join(base_path, 'models', 'maps', "#{map_name}.json"))
      JSON.parse(file.read)
    end

    def elements(elem_name)
      file = File.open(File.join(base_path, 'models', 'maps', "#{map_name}.json"))
      JSON.parse(file.read)
    end
    private

    attr_reader :base_path

  end
end
