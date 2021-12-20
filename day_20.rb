class FloorMap
  def initialize(in_lines)
    @the_map = []
    @default_char = "."
    in_lines.each do |line|
      @the_map << line.chomp.chars
    end
    @size_x = @the_map[0].size
    @size_y = @the_map.size
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def char_for(in_x, in_y)
    return @default_char if !on_map?(in_x, in_y)
    @the_map[in_y][in_x]
  end

  def show_info
    puts @size_x
    puts @size_y
  end

  def lit_count
    the_count = 0
    @size_y.times do |y|
      the_count += @the_map[y].count { |c| c == "#" }
    end
    the_count
  end

  def unlit_count
    the_count = 0
    @size_y.times do |y|
      the_count += @the_map[y].count { |c| c == "." }
    end
    the_count
  end

  def show_grid
    @size_y.times do |y|
      puts @the_map[y].join
    end
  end

  def iterate(algo)
    new_lines = []
    -1.upto(@size_y) do |y|
      outline = []
      -1.upto(@size_x) do |x|
        the_index_string = ""
        the_index_string += char_for(x - 1, y - 1) + char_for( x, y - 1) + char_for( x + 1, y - 1)
        the_index_string += char_for(x - 1, y) +     char_for( x, y) +     char_for( x + 1, y)
        the_index_string += char_for(x - 1, y + 1) + char_for( x, y + 1) + char_for( x + 1, y + 1)
        the_index = the_index_string.tr(".#","01").to_i(2)
        outline << algo[the_index]
      end
      new_lines << outline
    end
    the_index_string = @default_char * 9
    the_index = the_index_string.tr(".#","01").to_i(2)
    @default_char = algo[the_index]

    @the_map = new_lines
    @size_x += 2
    @size_y += 2
  end
end

all_lines = File.read('day_20_input.txt').split("\n")

algo = all_lines[0].strip

floormap = FloorMap.new(all_lines[2..-1])

50.times do |step|
  floormap.iterate(algo)
end
puts floormap.lit_count
