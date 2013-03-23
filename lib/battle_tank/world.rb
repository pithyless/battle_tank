class World
  def initialize(width, height)
    @width, @height = width, height
    init_world
  end

  def coords
    @coords ||= []
  end

  def init_world
    height.times.each do |y|
      coords[y] = ' ' * width
    end
  end

  attr_reader :width, :height

  def add(x, y, value)
    if value.kind_of?(String)
      add_line(x, y, value)
    elsif value.kind_of?(Array)
      value.each_with_index do |line, idx|
        add_line(x, y + idx, line)
      end
    end
  end

  private
  def add_line(x, y, string)
    string.each_char.with_index do |c, idx|
      coords[y][idx + x] = c
    end
  end
end
