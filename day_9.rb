class HeightMap
  attr_reader :size_x, :size_y

  DELTA_MOVES = [[ 0,-1],[-1, 0],[ 1, 0],[ 0, 1]]

  def initialize(in_filename)
    @height_map = []
    File.open(in_filename).each do |line|
      @height_map << line.chomp.chars.map(&:to_i)
    end
    @size_x = @height_map[0].size
    @size_y = @height_map.size
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def is_local_low?(in_x, in_y)
    return false if !on_map?(in_x, in_y)

    height = @height_map[in_y][in_x]
    all_lower = true
    DELTA_MOVES.each do |move|
      delta_x, delta_y = move[0], move[1]
      if on_map?(in_x + delta_x, in_y + delta_y)
        if @height_map[in_y+delta_y][in_x+delta_x] <= height
          all_lower = false
        end
      end
    end
    all_lower
  end

  def risk_level_sum
    total = 0
    @size_x.times do |x|
      @size_y.times do |y|
        if is_local_low?(x,y)
          total += (@height_map[y][x] + 1)
        end
      end
    end
    total
  end

  def key_for(x,y)
    "#{x}_#{y}"
  end

  def add_to_basin(in_basin, x, y)
    return if in_basin.has_key?(key_for(x,y))
    in_basin[key_for(x,y)] = 1

    DELTA_MOVES.each do |move|
      delta_x, delta_y = move[0], move[1]
      if on_map?(x + delta_x, y + delta_y) && @height_map[y+delta_y][x+delta_x] < 9
        add_to_basin(in_basin, x+delta_x, y+delta_y)
      end
    end
    in_basin
  end

  def get_basin_size(x,y)
    the_basin = {}
    the_basin = add_to_basin(the_basin, x, y)
    the_basin.length
  end

  def basin_sizes
    basin_sizes = []
    @size_x.times do |x|
      @size_y.times do |y|
        if is_local_low?(x,y)
          basin_sizes << get_basin_size(x,y)
        end
      end
    end
    basin_sizes
  end

  def show_info
    puts @size_x
    puts @size_y
  end
end

the_map = HeightMap.new('day_9_input.txt')
# the_map.show_info
puts the_map.risk_level_sum
puts the_map.basin_sizes.sort! { |x, y| y <=> x }[0..2].inject(:*)

